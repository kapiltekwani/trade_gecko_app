class ObjectState
  include Mongoid::Document	
  require 'csv'
  #Add uniqinuess constraint on combination of object_id, object_type & timestamp
  field :object_id, type: Integer
  field :object_type, type: String
  field :object_changes, type: String
  field :timestamp, type: DateTime  

  attr_accessible :object_id, :object_type, :timestamp, :object_changes

  validates :object_id, :object_type, :timestamp, :object_changes, presence: true

  validates :object_id, numericality: { only_integer: true }
end
