require './log'

class LogStore < ActiveRecord::Migration
	def self.up
		create_table 	:logs do |t|			
			t.integer		:entry_id
			t.string 		:entry
			t.integer 	:timestamp
			t.string		:environment
			t.integer		:error_status
		end
	end
end

LogStore.new.up
