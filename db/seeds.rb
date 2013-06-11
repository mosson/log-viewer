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

insert_data = [
    {
        entry_id: 123,
        entry: "hello",
        timestamp: 20130611,
        error_status: 404,
        environment: "test"
    },
    {
        entry_id: 456,
        entry: "world",
        timestamp: 20130611,
        error_status: 500,
        environment: "test"
    }
]

puts "Completed!"