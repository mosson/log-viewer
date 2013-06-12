require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require './lib/sinatra/paginate'
require './log'
require 'octokit'
require 'yaml'
require 'haml'

TARGET_REPO = "a-munakata/sinatra-app"

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
	client = Octokit::Client.new login: ENV["GITHUB_USER"], password: ENV["GITHUB_PASSWORD"]
	api_response = client.create_issue TARGET_REPO, params[:title], params[:body]
	api_response = client.create_issue TARGET_REPO, params[:title], params[:body] unless params[:title].nil? && params[:body].nil?
	redirect api_response.html_url
end

get "/:environment" do
	# @logs            = Log.where(:environment => params[:environment]).limit(10).offset(page * 10)
	# @logs_total 		 = Log.where(:environment => params[:environment])
	@logs            = Log.limit(10)
	@logs_total 		 = Log.all
	@result 				 = Struct::Result.new(@logs_total.count, @logs.count, @logs)
	@title 					 = params[:environment]

	haml :environment	
end

get "/env/css/styles.css" do
	css :stylesheet
end
