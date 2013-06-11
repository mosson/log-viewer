require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require './lib/sinatra/paginate'
require './log'
require 'octokit'
require 'yaml'


TARGET_REPO = "a-munakata/sinatra-app"

class SinatraApp < Sinatra::Base
	register Sinatra::Paginate

	helpers do
		def page
			[params[:page].to_i - 1, 0].max
		end
	end
end

Struct.new("Result", :total, :size, :logs)

get "/" do
	@logs = Log.all
	haml :index
end

get "/env/:environment" do	
	@production_logs = Log.where(:environment => params[:environment]).limit(10).offset(page * 10)
	@logs_total 		 = Log.where(:environment => params[:environment])	
	@result 				 = Struct::Result.new(@logs_total.count, @production_logs.count, @production_logs)
	@title 					 = params[:environment]

	haml :environment

end

post "/put" do
	data_yml = YAML.load_file("db/staging-20130601.yml")
	data_yml.each do |test|
		test.each do |t|	
			if t.instance_of?(Hash)
				insert_data = Log.new( 
         :entry 			 => t["entry"],
				 :timestamp 	 => t["timestamp"], 
				 :error_status => t["error_status"], 
				 :environment  => t["environment"])

				insert_data.save
			end		
		end
	end
 	redirect "/"
end

