require './app'
require 'erb'
dirname = "./db/data"

Dir::entries(dirname).each do |file|	
	if file.match(/erb/)
		
		fname = Dir::pwd + "/db/data/" + file
		puts "inserting #{file} into database..."

		begin
			erb = ERB.new(File.read(fname)).result(binding)
			erb.filename = fnameputs erb.filename
		rescue => e			
			puts "ERROR::error at #{fname}"
			puts e
		end
		
		
	end
	
end



