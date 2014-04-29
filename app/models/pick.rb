# == Schema Information
#
# Table name: picks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  link        :string(255)
#  host_id     :integer
#  episode_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Pick < ActiveRecord::Base
  belongs_to :host
  belongs_to :episode
  # attr_accessible :description, :link, :name, :host_id

  validates_presence_of :host_id
  def self.for_show(show)
    if show
      joins(:episode).where(episodes: { show_id: show.id })
    else
      all
    end
  end

  def self.search(search_terms)
    where("name @@ :q OR picks.description @@ :q", q: search_terms)
  end
end
