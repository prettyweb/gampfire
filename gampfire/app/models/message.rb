class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
end
# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  room_id    :integer
#  body       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

