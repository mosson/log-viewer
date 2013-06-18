require 'active_record'
	ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ENV["DB_PATH"]

class Log < ActiveRecord::Base
	default_scope {order(:timestamp)}
end