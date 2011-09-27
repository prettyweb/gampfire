class Room < ActiveRecord::Base
  has_many :users
end
# == Schema Information
#
# Table name: rooms
#
#  id              :integer         not null, primary key
#  topic           :string(255)
#  root_auth_code  :string(255)
#  last_message_id :integer
#  private         :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

