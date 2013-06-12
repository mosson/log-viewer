require 'active_record'

if production?
ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => "/www/rails/log-viewer/current/db/data.sqlite"
else
ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => "./db/data.sqlite"
end



class Log < ActiveRecord::Base
	default_scope {order(:timestamp)}
end