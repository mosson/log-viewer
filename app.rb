require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require './lib/sinatra/paginate'
require './log'
require 'octokit'
require 'yaml'
require 'haml'

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
	api_response = client.create_issue TARGET_REPO, params[:title], params[:body] + params[:comment] unless params[:title].nil? && params[:body].nil?	
	Log.where(:id => params[:id]).first.update_attribute(:github_issued, true)
	redirect api_response.html_url	
	# redirect "/production"
end

get "/invalid" do
	"Invalid argument"	
end

get "/:environment" do
	@logs            = Log.where(:environment => params[:environment]).order(:timestamp => "DESC")
	haml :environment
end


post "/:environment" do
	@logs            = Log.where(:error_status => params[:status_code]).order(:timestamp => "DESC") unless params[:status_code].nil?
	
		
	Log.all.each do |log|
		if log.entry.match(/#{params[:backtrace]}/)
			@logs = log
		end
	end

	haml :environment

	

end


get "/env/css/styles.css" do
	css :stylesheet
end
