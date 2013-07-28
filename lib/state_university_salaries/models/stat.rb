class Stat < ActiveRecord::Base
  belongs_to :school
  belongs_to :person

  class << self
  	def calculate_top_lists
      schools = School.all

      tops = [nil]
      tops = tops + schools
      tops.each do |s|
        query = if s.nil?
          "SELECT p.id AS person_id, p.first_name || ' ' || p.last_name AS name, SUM(y.rate) AS value FROM people p JOIN payments y ON y.person_id = p.id GROUP BY p.id ORDER BY 3 DESC LIMIT 100"
        else
          "SELECT p.id AS person_id, p.first_name || ' ' || p.last_name AS name, SUM(y.rate) AS value FROM people p JOIN payments y ON y.person_id = p.id WHERE y.school_id = #{s.id} GROUP BY p.id ORDER BY 3 DESC LIMIT 100"
        end
      	stats = Stat.find_by_sql query
      	stats.each do |t|
      	  stat = Stat.new title: "Top 100 List"
      	  stat.school_id = s.id unless s.nil?
      	  stat.name = t.name
      	  stat.person_id = t.person_id
      	  stat.value = t.value
      	  stat.save
      	end

      	puts "      tops for school #{s}"
      end
    end	

    def calculate_mean
      schools = School.all

      means = [nil]
      means = means + schools
      means.each do |s|
      	stat = Stat.new title: "Mean Salary"
      	stat.name = s.nil? ? "State Mean" : s.name
      	stat.school_id = s.id unless s.nil?

      	count = s.nil? ? Payment.count : Payment.where(school_id: s.id).count
      	val = s.nil? ? Payment.sum(:rate) : Payment.where(school_id: s.id).sum(:rate)
      	stat.value = (val / count.to_f).round(2)

      	stat.save
      end
    end

    def calculate_median
   	  precision = 1000
   	  schools = School.all

      medians = [nil]
      medians = medians + schools
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
        stat.value = (payment.rate * precision).round(2)
        stat.save
      end
    end

    def calculate_funding_sources
   	  schools = School.all
      programs = Program.all

      sources = [nil]
      sources = sources + schools
      sources.each do |s|
        programs.each do |p|
          sum = Payment.where(program_id: p.id)
          sum = sum.where(school_id: s.id) unless s.nil?
          sum = sum.sum(:rate).round(2)

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
      titles = titles + schools
      titles.each do |s|
        classes.each do |c|
          sum = if s.nil? 
          	Payment.where(title_id: c.id)
          else
          	Payment.where(title_id: c.id, school_id: s.id)
          end
          sum = sum.average(:rate) || 0
          sum = sum.round(2)

          stat = Stat.new title: "Class Titles"
          stat.school_id = s.id unless s.nil?
          stat.name = c.name || 'N/A'
          stat.value = sum
          stat.save      	
        end
      end
    end
  end
end