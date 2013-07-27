module SUS
  class Database
  	def create(name, path)
      filename =  "#{path}/#{name}.sqlite".gsub(/\/\//, '/')

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
  	  	Registration.delete_all
  	  	Compensation.delete_all
  	  	Lobbyist.delete_all
  	  	Firm.delete_all
  	  	Principal.delete_all
  	  	Phone.delete_all
  	  	Address.delete_all
  	  end

  	  def migrate_database_schemas
		ActiveRecord::Migration.create_table :naics_codes do |t|
		  t.string :name
		  t.string :code
		end

		ActiveRecord::Migration.create_table :phones do |t|
	      t.references :owner, :polymorphic => true
	      t.string :number
	      t.string :extension
		end
		ActiveRecord::Migration.add_index :phones, [:owner_id, :owner_type]

		ActiveRecord::Migration.create_table :addresses do |t|
	      t.references :owner, :polymorphic => true
	      t.string :street_1
	      t.string :street_2
	      t.string :street_3
	      t.string :state
	      t.string :city
	      t.string :zip
		end
		ActiveRecord::Migration.add_index :addresses, [:owner_id, :owner_type]

		ActiveRecord::Migration.create_table :lobbyists do |t|
	      t.string :first_name
	      t.string :last_name
	      t.string :middle_name
	      t.string :normal_name
	      t.string :full_name
	      t.string :suffix
	      t.string :email
	      t.string :state
	      t.date :suspended_at
		end
		ActiveRecord::Migration.add_index :lobbyists, :normal_name, :unique => true
		ActiveRecord::Migration.add_index :lobbyists, [:last_name, :first_name]

		ActiveRecord::Migration.create_table :principals do |t|
	      t.string :name
	      t.string :normal_name
		end
		ActiveRecord::Migration.add_index :principals, :normal_name, :unique => true

		ActiveRecord::Migration.create_table :firms do |t|
	      t.string :name
	      t.string :normal_name
	      t.string :email
		end
		ActiveRecord::Migration.add_index :firms, :normal_name, :unique => true

		ActiveRecord::Migration.create_table :registrations do |t|
	      t.references :naics_code
	      t.references :firm
	      t.references :principal
	      t.references :lobbyist
	      t.string :branch
	      t.string :state
	      t.date :effective_at
	      t.date :withdrawl_at
		end
		ActiveRecord::Migration.add_index :registrations, :lobbyist_id
		ActiveRecord::Migration.add_index :registrations, :principal_id
		ActiveRecord::Migration.add_index :registrations, :firm_id

		ActiveRecord::Migration.create_table :compensations do |t|
	      t.references :firm
	      t.references :principal
	      t.string :range
	      t.string :branch
	      t.string :certification_agent_name
	      t.string :certification_agent_title
	      t.integer :quarter
	      t.integer :minimum
	      t.integer :maximum
	      t.date :submitted_at
		end
		ActiveRecord::Migration.add_index :compensations, :principal_id
		ActiveRecord::Migration.add_index :compensations, :firm_id
  	  end
  end
end