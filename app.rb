require 'sinatra/base'
require 'sinatra/reloader' if development?
require './lib/sinatra/paginate'
require './log'
require 'yaml'
require 'octokit'

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

post '/post_issue' do	
	client = Octokit::Client.new login: ENV["GITHUB_USER"], password: ENV["GITHUB_PASSWORD"]
	api_response = client.create_issue TARGET_REPO, params[:title], params[:body]
	redirect api_response.html_url
end

get "/production" do
	@production_logs = Log.where(:environment => "production").limit(10).offset(page * 10)
	@logs_total 		 = Log.where(:environment => "production")	
	@result 				 = Struct::Result.new(@logs_total.count, @production_logs.count, @production_logs)
	@title 					 = "PRODUCTION"

	haml :show_logs
end

get "/staging" do
	@staging_logs = Log.where(:environment => "staging").limit(10).offset(page * 10).order(:timestamp => "DESC")
	@logs_total 	= Log.where(:environment => "staging")
	@result		 		= Struct::Result.new(@logs_total.count, @staging_logs.count, @staging_logs)
	@title 				= "STAGING"
	
	haml :show_logs
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

