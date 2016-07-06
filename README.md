# JefferiesTube

A collection of useful tools used at Ten Forward Consulting

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

## Contributing

1. Fork it ( http://github.com/<my-github-username>/jefferies_tube/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
