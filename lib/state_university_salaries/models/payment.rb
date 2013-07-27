class Payment < ActiveRecord::Base
  belongs_to :person
  belongs_to :course
  belongs_to :program

  def ops?; /ops/i.match(employee_type) ? true : false; end
end

