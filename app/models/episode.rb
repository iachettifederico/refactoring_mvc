class Episode < ActiveRecord::Base
  include Slugger

  # Associations
  belongs_to :show
  has_many :episode_hosts, -> { where guest: false}
  has_many :episode_guests, -> { where guest: true}, :class_name => "EpisodeHost"
  has_many :hosts, through: :episode_hosts

  has_many :picks
  accepts_nested_attributes_for :picks, allow_destroy: true

  has_one :audio
  accepts_nested_attributes_for :audio

  has_one :video
  accepts_nested_attributes_for :video

  # Validations
  validates_presence_of :title
  validates_format_of :duration, with: /\d{1,2}:\d\d(:\d\d)+(.\d\d\d)+/, allow_nil: true, allow_blank: true

  # Scopes
  scope :recent,    -> { order("created_at DESC").limit(2) }
  scope :published, -> { where('published_at <= ?', Time.now).order('published_at DESC') }

  def hosts_label
    label = self.show.host_name
    label = label.pluralize if self.hosts.count > 1
    label
  end

  def guests_label
    label = "Guest"
    label = label.pluralize if self.guests.count > 1
    label
  end

  def fill_blank_feeds
    (show.feeds - self.feeds).each do |feed|
      self.episode_media.build(feed: feed)
    end
  end

  def url
    "#{self.show.url}/#{self.slug}"
  end

  def previous
    self.show.episodes.where("published_at < ?", self.published_at).first
  end

  def next
    self.show.episodes.where("published_at > ?", self.published_at).last
  end

  def main_medium_url
    self.audio && self.audio.url
  end

  def file_prefix
    show.file_prefix
  end

  def show_slug
    show.slug
  end

  def show_slug=(slug)
    show = Show.find(slug)
    write_attribute(:show_id, show.id)
  end

  def self.most_popular(count: nil, keen_gateway: KeenGateway.new)
    episodes = keen_gateway
      .most_popular_episodes
      .each_with_object({}) do |res, hash|
      episode = Episode.find(res.first)
      hash[episode] = res.last
    end

    ordered = episodes.sort { |a, b|
      [b.last, b.first.published_at.to_i] <=> [a.last, a.first.published_at.to_i]
    }

    if count
      ordered.map(&:first).take(count)
    else
      ordered.map(&:first)
    end
  end

  def self.create_from_xpath(xpath, show)
    if xpath.xpath("./wp:status").text == "publish"
      episode = Episode.new
      episode.show = show
      episode.title = xpath.xpath("./title").text
      episode.slug = xpath.xpath("./wp:post_name").text
      episode.show_notes = xpath.xpath("./content:encoded").text.gsub("[powerpress]", "")
      episode.livefyre_article_id = xpath.xpath("./wp:post_id").text
      episode.published_at = DateTime.parse(xpath.xpath("./wp:post_date").text || xpath.xpath("./pubDate").text)
      episode.guid = xpath.xpath("./guid").text
      enclosure = extract_enclosure(xpath)
      unless enclosure == 0
        Audio.create_from_enclosure(enclosure, episode)
      end
      episode.save
      episode
    end
  end

  def to_s
    title
  end

  def published_at=(date)
    case date
    when Time
      super
    when DateTime
      super
    when Date
      write_attribute(:published_at, date.to_datetime)
    when String
      write_attribute(:published_at, Date.strptime(date, "%m/%d/%Y"))
    end
  end

  def sponsors
    show.sponsors
  end

  private

  def self.extract_enclosure(xpath)
    xpath.xpath("./wp:postmeta").each do |meta|
      return meta.xpath("./wp:meta_value").text if meta.xpath("./wp:meta_key").text == "enclosure"
    end
  end
end
