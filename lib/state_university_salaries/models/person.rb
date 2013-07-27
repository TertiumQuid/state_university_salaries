class Person < ActiveRecord::Base
  self.table_name = "people"

  belongs_to :school

  def full_name
  	[first_name,last_name].join(' ')
  end
end

