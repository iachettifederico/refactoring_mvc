module Slugger
  def self.included(base)
    base.before_save :set_slug
    def base.find(*args)
      if args.first.is_a? String
        find_by_slug(args) || super(args)
      else
        super(args)
      end
    end
  end

  def to_key
    Array(slug)
  end

  def to_param
    slug
  end

  def set_slug
    if slug.blank?
      tmp_slug = title.gsub(/[^A-Za-z0-9]/, '-').gsub(/--+/, '-').downcase
      collisions = Episode.select("slug").where(["slug like ?", "#{tmp_slug}%"]).load
      if collisions.empty?
        self.slug = tmp_slug
      else
        numbers = collisions.map(&:slug).map {|s| s.gsub(/#{tmp_slug}-?/, '').to_i}
        self.slug = "#{tmp_slug}-#{numbers.max+1}"
      end
    end
  end
end
