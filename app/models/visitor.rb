class Visitor < ActiveRecord::Base
  scope :with_contact_info, includes(:user)

  belongs_to :event
  belongs_to :user

  accepts_nested_attributes_for :user

  attr_accessible :event_id, :user_id, :event, :user, :user_attributes
end
