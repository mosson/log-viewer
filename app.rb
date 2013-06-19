require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require './log'
require 'octokit'
require 'yaml'
require 'haml'
require './lib/paginate'

TARGET_REPO = "a-munakata/log-factory"

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
	
	data = erb :issue_template

	api_response = client.create_issue TARGET_REPO, params[:title], data unless params[:title].nil? && params[:body].nil?	
	Log.where(:id => params[:id]).first.update_attribute(:github_issued, true)
	redirect api_response.html_url	
	redirect "/production"
end

get '/invalid' do
	"Invalid argument"	
end


get '/:environment/:page' do
	@logs            = Log.envs(params[:environment]).limit(10).offset(10 * params[:page].to_i)
	haml :environment
end


get '/:environment' do
	@logs            = Log.envs(params[:environment])
	haml :environment	
end

post '/:environment' do
	@backtrace = params[:backtrace]
	@environment = params[:environment]
	@status_code = params[:status_code]	
	@date_from = params[:date_from]
	@date_to = params[:date_to]

	@logs = Log.envs(@environment).where(:error_status => @status_code) unless @status_code.nil?
	@logs = Log.envs(@environment).where('entry LIKE ?', '%#{@backtrace}%').all unless @backtrace.nil?
	@logs = Log.envs(@environment).where(:timestamp => @date_from.to_time..@date_to.to_time) unless @date_from.nil? && @date_to.nil?	

	haml :environment
end


get '/env/css/styles.css' do
	css :stylesheet
end
