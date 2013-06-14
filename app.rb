require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require './lib/sinatra/paginate'
require './log'
require 'octokit'
require 'yaml'
require 'haml'

TARGET_REPO = "a-munakata/log-factory"

Struct.new("Result", :total, :size, :logs)

class SinatraApp < Sinatra::Base
	register Sinatra::Paginate

	helpers do
		def page
			[params[:page].to_i - 1, 0].max
		end
	end
end

get "/" do
	@logs = Log.all
	@environments = ["production", "staging"]
	haml :index
end

get '/style.css' do
	css :stylesheet
end

post '/issue' do	
	redirect "/invalid" if params[:title].nil? || params[:body].nil?

	client = Octokit::Client.new login: ENV["GITHUB_USER"], password: ENV["GITHUB_PASSWORD"]
	api_response = client.create_issue TARGET_REPO, params[:title], params[:body] unless params[:title].nil? && params[:body].nil?	
	Log.where(:id => params[:id]).first.update_attribute(:github_issued, true)
	redirect api_response.html_url	
	# redirect "/production"
end

get "/invalid" do
	"Invalid argument"	
end

get "/:environment" do
	@logs            = Log.where(:environment => params[:environment])
	@logs_total 		 = Log.where(:environment => params[:environment])
	# @logs            = Log.where()
	# @logs_total 		 = Log.all
	@result 				 = Struct::Result.new(@logs_total.count, @logs.count, @logs)
	@title 					 = params[:environment]	
	haml :environment
	
	# @logs = Log.where(:backtrace => params[:backtrace]) unless params[:backgrace.nil]?
	# @logs = Log.where(:timestamp => params[:data_to]) unless params[:data_to.nil]?
end

post "/:environment" do
	@logs            = Log.where(:error_status => params[:status_code])
	@logs_total 		 = Log.where(:error_status => params[:status_code])
	# @logs            = Log.where()
	# @logs_total 		 = Log.all
	@result 				 = Struct::Result.new(@logs_total.count, @logs.count, @logs)
	@title 					 = params[:environment]	
	haml :environment

	# @logs 					 = Log.where(:status_code => params[:status_code])
	# @logs_total 		 = Log.where(:status_code => params[:status_code])
end


get "/env/css/styles.css" do
	css :stylesheet
end
