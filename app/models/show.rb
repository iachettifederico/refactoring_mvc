# == Schema Information
#
# Table name: shows
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  description               :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cover_art_file_name       :string(255)
#  cover_art_content_type    :string(255)
#  cover_art_file_size       :integer
#  cover_art_updated_at      :datetime
#  twitter_link              :string(255)
#  facebook_link             :string(255)
#  google_link               :string(255)
#  rss_link                  :string(255)
#  email                     :string(255)
#  domain                    :string(255)
#  slug                      :string(255)
#  host_name                 :string(255)      default("Host")
#  livefyre_site_id          :string(255)
#  itunes_url                :string(255)
#  ftp_user                  :string(255)
#  ftp_pass                  :string(255)
#  ftp_server                :string(255)
#  ftp_path                  :string(255)
#  ftp_url                   :string(255)
#  file_prefix               :string(255)
#  embedded_video_dimensions :string(255)
#

class Show < ActiveRecord::Base
  include Slugger

  validates_presence_of :domain
  validate :embedded_video_dimensions_format

  # Associations
  has_and_belongs_to_many :hosts

  has_many :show_feeds
  has_many :feeds, through: :show_feeds

  has_many :episodes, -> { order "published_at DESC" }, dependent: :destroy

  has_many :sponsors, through: :sponsorships
  has_many :sponsorships
  accepts_nested_attributes_for :sponsors

  before_save :sanitize_domain

  def remove_previously_stored_cover_art
    if cover_art_was.nil?
      super
    end
  end

  def import_wxr(file)
    # return nil unless file.is_a? File
    xml = Nokogiri::XML(file.read)
    episodes = xml.xpath("//item")
    episodes.each do |episode|
      episode = Episode.create_from_xpath(episode, self)
      self.episodes << episode if episode
    end
  end

  def url
    domain.present? ? "http://#{domain}" : ""
  end

  def rss_url
    url.present? ? "#{url}/podcast.rss" : ""
  end

  def transcripts_rss_url
    url.present? ? "#{url}/transcripts.rss" : ""
  end

  def embedded_video_dimensions
    read_attribute(:embedded_video_dimensions) || "500x300"
  end

  def embedded_video_width
    embedded_video_dimensions[/\A(\d+)x\d+\Z/, 1]
  end

  def embedded_video_height
    embedded_video_dimensions[/\A\d+x(\d+)\Z/, 1]
  end

  def tags
    Episode.where(show_id: id).tag_counts
  end

  def to_s
    title
  end

  def published_episodes
    episodes.published.all
  end

  def root_url
    show_path =  ""
    show_path << "http://#{domain}"
    show_path << port
  end

  def active_sponsorships
    sponsorships.active
  end

  private

  def port
    (":#{ServerInfo.port}" if ServerInfo.port).to_s
  end

  def embedded_video_dimensions_format
    format_regex = /\A\d{3}x\d{3}\Z/i
    if embedded_video_dimensions && !(format_regex === embedded_video_dimensions)
      errors.add(:embedded_video_dimensions, "invalid format")
    end
  end

  def sanitize_domain
    self.domain = self.domain.gsub(/http(|s):\/\//, '')
  end
end
