# == Schema Information
#
# Table name: episode_hosts
#
#  id         :integer          not null, primary key
#  episode_id :integer
#  host_id    :integer
#  guest      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EpisodeHost < ActiveRecord::Base
  belongs_to :episode
  belongs_to :host
end
