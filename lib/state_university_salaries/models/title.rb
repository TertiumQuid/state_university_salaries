class Title < ActiveRecord::Base
  self.table_name = "classes"

  before_create :set_name

  def set_name
  	self.name ||= 'N/A'
  end
end