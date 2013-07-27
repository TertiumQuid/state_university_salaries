require 'sqlite3'
require 'csv'
require 'net/http'
require 'tempfile'
require 'securerandom'

module SUS
  class CLI < Thor
    desc "request", "Public records request."
    method_option :output, :type => :string, :required => true, :aliases => "-o", :desc => "Output directory for sqlite databases."
    def request
      puts "requesting salary data"
      
      client = SUS::Client.new options.output
      puts client.run
      send(state).gzip_output options.output
    end

    desc "version", "Print version number."
    def version
      puts "state_university_salaries version #{SUS::VERSION}"
    end
    map ["-v", "--version"] => :version

    desc "help", "Display gem usage information."
    def help
      SUS::CLI.tasks.each do |k,v|
        print_in_columns ["lda #{v.name}", "# #{v.description}"]
      end
    end
    map ["-h", "--help"] => :help
  end
end