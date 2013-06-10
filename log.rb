require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => "./data.sqlite"

class Log < ActiveRecord::Base
	default_scope {order(:timestamp).limit(10)}
end