class Payment < ActiveRecord::Base
  belongs_to :person
  belongs_to :title
  belongs_to :program
  belongs_to :school

  def ops?; /ops/i.match(employee_type) ? true : false; end
end

