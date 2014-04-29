class Host < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :shows
  has_many :websites
  has_many :episode_hosts
  has_many :episodes, through: :episode_hosts

  scope :for_shows, -> {
    joins(:episode_hosts).where("episode_hosts.guest = false")
  }

  def google_url
    google_plus_handle
  end

  def twitter_handle=(handle)
    handle = "@#{handle}" unless handle.starts_with? "@"
    write_attribute(:twitter_handle, handle)
  end

  def twitter_url
    "http://twitter.com/#{twitter_handle.strip.gsub("@", "")}"
  end

  def facebook_url
    "http://facebook.com/#{facebook_handle.strip}"
  end

  def github_url
    "http://github.com/#{github_handle.strip}"
  end

  def to_s
    name
  end

  def profile
    super || build_profile(blurb: "")
  end

end
