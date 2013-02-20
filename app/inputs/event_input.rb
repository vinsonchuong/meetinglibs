require 'csv'

class EventInput
  include ActiveModel::Validations

  attr_reader :name, :archived

  validates :name, presence: true

  def initialize(params)
    @name = params[:name]
    @archived = params[:archived]
    @hosts = params[:hosts]
    @visitors = params[:visitors]
  end

  def attributes
    {
      name: name,
      archived: archived,
      hosts_attributes: @hosts.present? ? hosts_attributes : [],
      visitors_attributes: @visitors.present? ? visitors_attributes : []
    }
  end

  def hosts_attributes
    CSV.parse(@hosts, headers:true).map(&:to_hash).map do |row|
      {user_attributes: {
        first_name: row['First Name'],
        last_name: row['Last Name'],
        email: row['Email'],
        cas_user: row['CalNet UID'],
        token: row['Login Token'],
      }}
    end
  end

  def visitors_attributes
    CSV.parse(@visitors, headers:true).map(&:to_hash).map do |row|
      {user_attributes: {
        first_name: row['First Name'],
        last_name: row['Last Name'],
        email: row['Email'],
        cas_user: row['CalNet UID'],
        token: row['Login Token'],
      }}
    end
  end
end
