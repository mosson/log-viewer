# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# roles: must be matched to stripe plans

require './log'

puts "inserting data..."

insert_data = Log.create([
    {
        entry_id: 123,
        entry: "hello",
        timestamp: 20130611,
        error_status: 404,
        environment: "staging"
    },
    {
        entry_id: 456,
        entry: "world",
        timestamp: 20130611,
        error_status: 500,
        environment: "production"
    },
    {
        entry_id: 3,
        entry: "Started GET \"/\" for 121.117.193.67 at 2013-05-31 15:23:21 +0000\nProcessing by HomeController#index as HTML\nFilter chain halted as :teaser_basic_auth rendered or redirected\nCompleted 401 Unauthorized in 1ms (ActiveRecord: 0.0ms)\n",
        timestamp: "2013-05-31 15:23:21 +0000",
        error_status: 401,
        environment: "staging"
    },
    {
        entry_id: 4,
        entry: "Started GET \"/\" for 121.117.193.67 at 2013-05-31 15:23:21 +0000\nProcessing by HomeController#index as HTML\nFilter chain halted as :teaser_basic_auth rendered or redirected\nCompleted 401 Unauthorized in 1ms (ActiveRecord: 0.0ms)\n",
        timestamp: "2013-05-31 15:23:21 +0000",
        error_status: 401,
        environment: "production"
    }
])


# insert_data.save

puts "Completed!"