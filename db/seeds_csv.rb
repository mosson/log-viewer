require './log'
require 'csv'

data = []
files = []

dir = Dir.new("./db/csv")


dir.each do |file|
	if file.match(/[0-9]{8}/)
		CSV.foreach("#{dir.path}/#{file}") { |entry|	
			data << {
				:entry => entry[0],
				:timestamp => entry[1],		
				:environment => entry[2],
				:error_status => entry[3],
				:github_issued => entry[4],
				:closed => entry[5],
				:updated => Time.now,
				:ip_address => entry[6]
			}
		}
	end
end

data.each do |log|	
	begin
		logs = Log.new(log) unless log[:entry].nil?
		logs.save unless logs.nil?
	rescue ActiveRecord::RecordNotUnique => e
		puts e	
	end	
end