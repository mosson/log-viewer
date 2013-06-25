require 'active_record'
	ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ENV["DB_PATH"]

class Log < ActiveRecord::Base
	attr_accessible :entry, :timestamp, :environment, :error_status, :github_issued, :closed, :updated
	default_scope { order("timestamp DESC") }
	scope :github, where(:github_issued => true)

  def self.envs(params)
    where(:environment => params)
  end
end
