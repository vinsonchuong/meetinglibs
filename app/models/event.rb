class Event < ActiveRecord::Base
  attr_accessible :name, :archived

  has_many :hosts
  has_many :visitors
end
