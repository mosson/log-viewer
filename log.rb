require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => "./db/data.sqlite"

class Log < ActiveRecord::Base
	default_scope {order(:timestamp)}
end