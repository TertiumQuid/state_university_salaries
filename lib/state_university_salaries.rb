require 'thor'
require 'active_record'
require 'spreadsheet'

require_relative "state_university_salaries/database"
require_relative "state_university_salaries/client"

require_relative "state_university_salaries/models/course"
require_relative "state_university_salaries/models/payment"
require_relative "state_university_salaries/models/person"
require_relative "state_university_salaries/models/program"
require_relative "state_university_salaries/models/school"

require_relative "state_university_salaries/version"
require_relative "state_university_salaries/cli"