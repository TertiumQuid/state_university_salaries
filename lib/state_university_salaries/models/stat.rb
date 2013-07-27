class Stat < ActiveRecord::Base
  belongs_to :school

  class << self
  	def calculate_top_lists
      schools = School.all

      tops = [nil]
      tops << schools
      tops.each do |s|
      	payments = Payment.limit(100)
      	payments = payments.where(school_id: s.id ) unless s.nil?
      	payments = payments.includes(:person).order("rate DESC")
      	payments.each do |p|
      	  stat = Stat.new title: "Top 100 List"
      	  stat.school_id = s.id unless s.nil?
      	  stat.name = payment.person ? payment.person.full_name : 'Unavailable'
      	  stat.value = payment.rate
      	  stat.save
      	end
      end  	
    end	

  
  end
end