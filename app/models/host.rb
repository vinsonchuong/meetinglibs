class Host < ActiveRecord::Base
  scope :with_contact_info, includes(:user).order('users.last_name, users.first_name')

  belongs_to :event
  belongs_to :user

  accepts_nested_attributes_for :user

  attr_accessible :event_id, :user_id, :event, :user, :user_attributes
end
