require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require './log'
require 'octokit'
require 'yaml'
require 'haml'
require './lib/paginate'
require './app'

run Sinatra::Application