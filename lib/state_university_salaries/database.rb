module SUS
  class Database
  	def create(filename)
      if File.exists?(filename)
      	puts " found database at #{filename}"
      	connect filename
      	drop
      else
        puts " creating database #{filename}..."
        SQLite3::Database.new(filename)
        connect filename
        puts " creating schema..."
        migrate_database_schemas
      end

    rescue Exception => e
      puts "create database ERROR #{e.message}"
  	end

  	private

  	  def connect(filename)
        ActiveRecord::Base.establish_connection(
          :adapter => 'sqlite3',
          :database => filename
        )
  	  end

  	  def drop
  	  	Course.delete_all
  	  	Payment.delete_all
  	  	Person.delete_all
  	  	Program.delete_all
  	  	School.delete_all
  	  end

  	  def migrate_database_schemas
    		ActiveRecord::Migration.create_table :schools do |t|
    		  t.string :name
    		end

    		ActiveRecord::Migration.create_table :programs do |t|
    		  t.string :name
    		end

    		ActiveRecord::Migration.create_table :classes do |t|
    		  t.string :name
    		  t.string :code
    		end

    		ActiveRecord::Migration.create_table :people do |t|
  	      t.references :school
  	      t.string :first_name
  	      t.string :last_name
    		end
    		ActiveRecord::Migration.add_index :people, :school_id

    		ActiveRecord::Migration.create_table :payments do |t|
  	      t.references :person
  	      t.references :program
  	      t.references :course
  	      t.string :employee_type
  	      t.float  :fte
  	      t.float  :rate
    		end
    		ActiveRecord::Migration.add_index :payments, :course_id
    		ActiveRecord::Migration.add_index :payments, :program_id
    		ActiveRecord::Migration.add_index :payments, :person_id

        ActiveRecord::Migration.create_table :stats do |t|
          t.references :school
          t.string :title
          t.string :name
          t.float :value
        end
        ActiveRecord::Migration.add_index :stats, :school_id
      end
  end
end