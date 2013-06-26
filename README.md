sinatra-app
=================

## Dependencies

gem 'sinatra'

gem 'activerecord'

gem 'sinatra-contrib'

gem 'octokit'

gem 'haml'

gem 'sqlite3'

gem 'capistrano'

gem 'sass'


## Settings
Environment valiables

- GITHUB_USER
- GITHUB_PASSWORD
- TARGET_REPO
- DB_PATH

- APP_NAME
- APP_REPO
- BRANCH_PATH
- HOST_IP
- HOST_USER

## Development
Migration

`rake db:migrate`

Insert seeds data to database

`rake db:seeds`