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

post '/post_issue' do	
	client = Octokit::Client.new login: ENV["GITHUB_USER"], password: ENV["GITHUB_PASSWORD"]
	api_response = client.create_issue TARGET_REPO, params[:title], params[:body] unless params[:title].nil? && params[:body].nil?
	redirect api_response.html_url
end

get "/env/:environment" do
		@logs 					 = Log.where(:environment => params[:environment]).limit(10).offset(page * 10)
		@logs_total 		 = Log.where(:environment => params[:environment])
		@result 				 = Struct::Result.new(@logs_total.count, @logs.count, @logs)

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

