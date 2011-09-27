class User < ActiveRecord::Base
  belongs_to :room

  def self.invite_to_room(room)
    user = User.new
    user.auth_code = ActiveSupport::SecureRandom.base64(14)
    user.room = room
    user.nickname = 'unknown'
    user.online = false
    user.save
    user
  end
end
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  auth_code  :string(255)
#  room_id    :integer
#  nickname   :string(255)
#  online     :boolean
#  created_at :datetime
#  updated_at :datetime
#

