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

    def calculate_mean
      schools = School.all

      means = [nil]
      means << schools
      means.each do |s|
      	stat = Stat.new title: "Mean Salary"
      	stat.name = s.nil? ? "State Mean" : s.name
      	stat.school_id = s.id unless s.nil?

      	count = s.nil? ? Payment.count : Payment.where(school_id: s.id).count
      	val = s.nil? ? Payment.sum(:rate) : Payment.where(school_id: s.id).sum(:rate)
      	stat.value = val / count.to_f

      	stat.save
      end
    end

    def calculate_median
   	  precision = 1000
   	  schools = School.all

      medians = [nil]
      medians << schools
      medians.each do |s|
        query = if s.nil?
          "SELECT DISTINCT round(rate / #{precision}, 2) AS rate FROM payments ORDER BY rate DESC"
        else
          "SELECT DISTINCT round(rate / #{precision}, 2) AS rate FROM payments WHERE school_id = #{s.id} ORDER BY rate DESC"
        end
        payments = Payment.find_by_sql query
        mid = (payments.size / 2).to_i
        payment = payments[mid]

      	stat = Stat.new title: "Median Salary"
      	stat.name = s.nil? ? "State Median" : s.name
      	stat.school_id = s.id unless s.nil?
        stat.value = payment.rate * precision
        stat.save
      end
    end

    def calculate_funding_sources
   	  schools = School.all
      programs = Program.all

      sources = [nil]
      sources << schools
      sources.each do |s|
        programs.each do |p|
          sum = Payment.where(program_id: p.id).sum(:rate)

          stat = Stat.new title: "Funding Sources"
          stat.school_id = s.id unless s.nil?
          stat.name = p.name
          stat.value = sum
          stat.save      	
        end
      end
    end

    def calculate_titles
   	  schools = School.all
      classes = Title.all

      titles = [nil]
      titles << schools
      titles.each do |s|
        classes.each do |c|
          sum = if s.nil? 
          	Payment.where(title_id: c.id)
          else
          	Payment.where(title_id: c.id, school_id: s.id)
          end
          sum = sum.avg(:rate)

          stat = Stat.new title: "Class Titles"
          stat.school_id = s.id unless s.nil?
          stat.name = p.name
          stat.value = sum
          stat.save      	
        end
      end
    end
  end
end