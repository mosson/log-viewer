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
	if params[:title].nil? || params[:body].nil?
		$invalid = "Empty Value was found."
		redirect "/invalid"
	end

	client = Octokit::Client.new login: ENV["GITHUB_USER"], password: ENV["GITHUB_PASSWORD"]
	
	data = erb :issue_template

	api_response = client.create_issue TARGET_REPO, params[:title], data unless params[:title].nil? && params[:body].nil?	
	Log.where(:id => params[:id]).first.update_attribute(:github_issued, true)
	redirect api_response.html_url	
	redirect "/production"
end

get '/invalid' do	
	haml :invalid
end

get '/:environment/:page' do
	redirect "/production" if params[:page] == "production"
	redirect "/staging" if params[:page] == "staging"
	@logs    = Log.envs(params[:environment]).limit(10).offset(10 * (params[:page].to_i - 1))
	
	paginate = Paginate.new()

	@max_num = Log.envs(params[:environment]).count/10 + 1	
	@result  = paginate.pages @max_num, 5, params[:page] unless params[:page].nil?
	
	haml :environment
end


get '/:environment' do	
	@logs  = Log.envs(params[:environment]).limit(10).offset(10 * (params[:page].to_i - 1))

	paginate = Paginate.new()

	@max_num = Log.envs(params[:environment]).count/10 + 1
	@result = paginate.pages @max_num, 5, 1
		
	haml :environment	
end

post '/:environment' do

	# redirect "/invalid" unless @date_from.to_time.instance_of? (Time) &&  @date_to.ti_time.instance_of? (Time)
	@backtrace = params[:backtrace]
	@environment = params[:environment]
	@status_code = params[:status_code]	
	@date_from = params[:date_from]
	@date_to = params[:date_to]

	@logs = Log.envs(@environment).where(:error_status => @status_code) unless @status_code.nil?
	@logs = Log.envs(@environment).where("entry LIKE ?", "%#{@backtrace}%") unless @backtrace.nil?
	@logs = Log.envs(@environment).where(:timestamp => @date_from.to_time..@date_to.to_time) unless @date_from.nil? && @date_to.nil?
	haml :environment	
end


get '/env/css/styles.css' do
	css :stylesheet
end
