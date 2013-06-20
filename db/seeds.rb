require './app'

Dir::entries("./db/data/").each do |file|
	# fname = File.open("./db/data/#{file}")
	# print fname.read
	# File.close
	# puts file
	require "./db/data/production-20130606"
end
