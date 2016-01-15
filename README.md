# JefferiesTube

A collection of useful tools used at Ten Forward Consulting

## Installation

Add this line to your application's Gemfile:

    gem 'jeffries_tube'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jeffries_tube

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
```
require 'jeffries_tube/capistrano'
```

Open rails console
```
cap beta rails:console
```

Open database console
```
cap beta rails:dbconsole
```

Open log
```
cap beta rails:log
```

Specify log file (if you're running a server in a differently named environment)
```
LOG=production cap beta rails:log
```

Make a database backup
```
cap beta db:backup
```

To enforce that you tagged the code before deploying, inside config/deploy/<stage>.rb:
```
before 'deploy', 'deploy:ensure_tag'
```


To automatically tag the code that is about to be released (lazy programmer solution) inside config/deploy/<stage>.rb:
```
before 'deploy', 'deploy:create_tag'
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

To get compass reset and box-sizing border-box to all elements

```
app/assets/stylesheets/application.sass

@import jefferies_tube
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/jeffries_tube/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
