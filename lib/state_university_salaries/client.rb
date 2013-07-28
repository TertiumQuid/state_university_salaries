module SUS
  class Client
    attr_accessor :temp_file

    SALARY_SHEETS_URL = "http://www.floridahasarighttoknow.com/docs/SUS_Data.xls"

    def run(output_file)
      puts " running"
      @temp_file = download_temp_file SALARY_SHEETS_URL
      ss = Spreadsheet.open @temp_file

      ss.worksheets.each do |w|
      	next if w.name == 'Coversheet'
      	puts "#{w.name}: #{w.rows.size}"

      	school = School.where(name: w.name).first_or_create
      	w.each 1 do |row|
          program = row[6] ? Program.where(name: row[6]).first_or_create : nil
          person = Person.where(last_name: row[1], first_name: row[2], school_id: school.id).first_or_create
          title = Title.where(name: row[11], code: row[10]).first_or_create
          
          payment = Payment.where(
          	person_id: person.id, 
          	program_id: program && program.id, 
          	school_id: school.id, 
          	title_id: title.id 
          ).first_or_initialize
          payment.employee_type = row[4]
          payment.fte = row[5]
          payment.rate = payment.ops? ? row[8] : row[7]
          payment.save
      	end
      end

      calculate_stats
      
      puts "  gzipping #{output_file}..."
      gzip_output output_file

      puts " ran"
    rescue => e
      puts e.message
      puts "---"
      puts e.backtrace
    ensure
      cleanup
    end

    def calculate_stats
      puts "  calculating stats"
      puts "    top lists"
      Stat.calculate_top_lists
      puts "    means"
      Stat.calculate_mean
      puts "    medians"
      Stat.calculate_median
      puts "    funding sources"
      Stat.calculate_funding_sources
      puts "    top class titles"
      Stat.calculate_titles
    end

    def gzip_output(input)
      puts `tar -cvzf #{input}.gz #{input}`
    rescue Exception => e
      puts "ERROR: could not gzip file"
    end

    def cleanup
      @temp_file.unlink unless @temp_file.nil?
    end    

	def download_temp_file(url)
	  uri = URI(url)
	  filename = File.basename(uri.path)
	  puts "downloading #{filename}"

	  Net::HTTP.start(uri.host, uri.port) do |http|
	    http.request_get(uri.path) do |response|
	      case response
	      when Net::HTTPNotFound
	        puts "client ERROR HTTPNotFound"
	        return false
	      when Net::HTTPClientError
	        puts "client ERROR HTTPClientError"
	        return false
	      when Net::HTTPRedirection
	        puts "client ERROR HTTPRedirection"
	        return false
	      when Net::HTTPOK
	      end

	      begin
	        @temp_file = Tempfile.new("#{filename}-#{SecureRandom.hex}")
	        @temp_file.binmode

	        size = 0
	        progress = 0
	        total = response.header["Content-Length"].to_i
	        total = 1 if total == 0

	        print "0%"
	        response.read_body do |chunk|
	          @temp_file << chunk
	          size += chunk.size
	          new_progress = (size * 100) / total
	          unless new_progress == progress
	            print "."
	          end
	          progress = new_progress
	        end
	        puts '100%'

	        @temp_file.close
	        return @temp_file
	      rescue Exception => e
	        puts ""
	        puts "client ERROR downloading #{filename}!!!"
	        puts e.message
	        @temp_file.unlink
	        return false
	      end
	    end
	  end      
	end
  end
end
