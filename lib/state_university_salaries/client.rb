module SUS
  class Client
    attr_accessor :temp_file

    SALARY_SHEETS_URL = "http://www.floridahasarighttoknow.com/docs/SUS_Data.xls"

    def run(output_file)
      puts " running"
      ss = download_temp_file SALARY_SHEETS_URL

      @temp_file = Spreadsheet.open (open(url))
      @temp_file.worksheets.each do |w|
      	puts w
      end

      puts " ran"
    rescue => e
      puts e.message
      puts "---"
      puts e.backtrace
    ensure
      cleanup
    end

    def gzip_output(input)
      puts `tar -cvzf #{input}.gz #{input}`
    rescue Exception => e
      puts "ERROR: could not gzip file"
    end

    def cleanup
      @temp_file.unlink unless @temp_file.blank?
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
