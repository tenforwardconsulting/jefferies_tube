# JefferiesTube

A collection of useful tools used at Ten Forward Consulting

[![Gem](https://img.shields.io/gem/v/jefferies_tube.svg)](https://rubygems.org/gems/jefferies_tube)

## Installation

Add this line to your application's Gemfile:

    gem 'jefferies_tube'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jefferies_tube

## Usage

### Error Handling

#### 404 Handling

JefferiesTube by default installs a catchall route that will render 404 for you and supress the rollbar error.  This also allows you to create super easy custom error pages.

Simple put a template in the parent app in `app/views/errors/404.haml` (or html or erb, etc) and it will be rendered instead of the default Jefferies tube error.

#### 500 handling

In progress -- not sure if this is super useful.

### Rake

* `rake db:backup`

Capture a database backup

* `rake db:restore`

Load most recent database backup. Can specify location of backup with `FILE`.

### Capistrano

Add this line *last* in your Capfile (it depends on rails/migrations and cap/deploy)
```ruby
require 'jefferies_tube/capistrano'
```

#### Tasks

* `cap beta ssh`

Open ssh session in `current` directory.

* `cap beta rails:console`

Open rails console.

* `cap beta rails:dbconsole`

Open database console.

* `cap beta rails:log`

Open log file. Can specify log file like so: `LOG=foobar cap beta rails:log`

* `cap beta rails:allthelogs`

Open the logfile for all servers (has the role :app) combined. Can specify log file like so: `LOG=foobar cap beta rails:allthelogs`

* `cap beta db:backup`

Make a database backup.

* `cap beta db:fetch`

Fetches the latest database backup. Useful for getting production data locally.

* `cap beta db:restore FILE=path/to/backup.dump`

Nuke the server's database with one you give it. Don't do this on production for obvious reasons. Useful for putting a backup fetched from production onto a dev server.

* `cap beta deploy:ensure_tag`

Yells at you if there is not a tag for your code.

* `cap beta deploy:create_tag`

Creates a tag for your code and pushes it.

#### Tagging

To enforce that you tagged the code before deploying, inside `config/deploy/<stage>.rb`:
```ruby
before 'deploy', 'deploy:ensure_tag'
```

To automatically tag the code that is about to be released (lazy programmer solution), inside `config/deploy/<stage>.rb`:
```ruby
before 'deploy', 'deploy:create_tag'
```

#### Bundler Audit

By default jefferies_tube will raise an error and stop if it detects any vulnerabilities is your installed gems. If you need to deploy anyway even with vulnerabilities you can do `I_KNOW_GEMS_ARE_INSECURE=true cap <environment> deploy`.

To ignore specific CVE's when running bundler-audit, inside `config/deploy.rb`:
```ruby
set :bundler_audit_ignore, ["CVE-1234-5678"]
```

### Enable/Disable Maintence Mode

```
cap production maintenance:enable MESSAGE="Site is down for maintenance, should be back shortly."
cap production maintenance:disable
```

### Whenever

JefferiesTube has backup functionality. To use it, add something like this to your `schedule.rb`:

```ruby
every 1.day, at: '12am' do
  rake 'db:backup'
end
```

For hourly backups:

```ruby
every :hour do
  rake 'db:backup:hourly'
end
```

Or for daily backups:

```ruby
every :day do
  rake 'db:backup:daily'
end
```

### Sass

To get compass reset and box-sizing border-box to all elements:
```sass
# app/assets/stylesheets/application.sass

@import jefferies_tube
```

### Development environment

When developing the apps against your local machine, it is useful to override some of the config settings to get ngrok to work.
You can create `config/environments/my.development.rb` and put something like the following in it:
```
Rails.application.configure do
  config.middleware.use "SomeLocalThing"
  config.action_mailer.asset_host = "test.ngrok.io"
  # Anything else in development.rb that you don't want to commit
end
```

If you do this, don't forget to add `my.development.rb` to the gitignore file.

### Terminal colors
Changes the prompt color of your terminal. Shows Development environments in blue, Test in yellow, and Production in a scary red.
Defaults to using the Rails env and Rails app class name, but configuration can be done in a Rails initializer like:
```
JefferiesTube.configure do |config|
  config.environment = 'production' # If you're using a nonstandard env name but want colors.
  config.prompt_name = 'ShortName' #For a shorter prompt name if you have a long app
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/jefferies_tube/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Add changes to the CHANGELOG file in the 'Unreleased' section.
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

### Release

- Update `lib/jefferies_tube/version.rb` with the new version number (be sure to follow
  [semver](https://semver.org/)).
- Update `CHANGELOG.md` and move everything in 'Unreleased' to a new section for the new version.
- Tag the final commit in that release.
