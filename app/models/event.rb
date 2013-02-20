class Event < ActiveRecord::Base
  scope :ordered, order('archived, created_at DESC')

  has_many :hosts
  has_many :visitors

  accepts_nested_attributes_for :hosts
  accepts_nested_attributes_for :visitors

  attr_accessible :name, :archived, :hosts_attributes, :visitors_attributes
end
