class EventInput
  include ActiveModel::Validations

  attr_reader :name, :archived

  validates :name, presence: true

  def initialize(params)
    @name = params[:name]
    @archived = params[:archived]
  end

  def attributes
    {name: name, archived: archived}
  end
end
