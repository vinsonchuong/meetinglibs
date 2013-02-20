class Host < ActiveRecord::Base
  scope :with_contact_info, includes(:user)

  attr_accessible :event_id, :user_id, :event, :user

  belongs_to :event
  belongs_to :user
end
