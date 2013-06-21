require './app'
require 'erb'
dirname = "./db/data"

Dir::entries(dirname).each do |file|	
	if file.match(/[0-9]{8}.erb/)
		
		fname = Dir::pwd + "/db/data/" + file
		puts "#{file} into database..."

		begin			
			
			ERB.new(File.read(fname)).result(binding)
		
		rescue => e			
		
			puts "ERROR::error at #{fname}"
			puts e
		
		end
				
	end
	
end



