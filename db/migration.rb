require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => "./data.sqlite"

class LogStore < ActiveRecord::Migration
	def self.up
		create_table 	:logs do |t|			
			t.integer		:entry_id
			t.string 		:entry
			t.datetime 	:timestamp
			t.string		:environment
			t.integer		:error_status
		end
	end
end

LogStore.new.up
