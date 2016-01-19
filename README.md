# JefferiesTube

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'jefferies_tube'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jefferies_tube

## Usage

### 404 Handling

Jefferies Tube by default installs a catchall route that will render 404 for you and supress the rollbar error.  This also allows you to create super easy custom error pages.

Simple put a template in the parent app in `app/views/errors/404.haml` (or html or erb, etc) and it will be rendered instead of the default Jefferies tube error.

### 500 handling

in progress -- not sure if this is super useful.

### Rake
Capture a database backup
```
rake db:backup
```

Load msot recent database backup
```
rake db:load
```

### Whenever
Jefferies tube has backup functionality. To use it, add something like this to your
schedule.rb
```
every 1.day, at: '12am' do
  rake 'db:backup'
end
```

### Capistrano

Add this line *last* in your Capfile (it depends on rails/migrations and cap/deploy)
```
require 'jefferies_tube/capistrano'
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

If you're using whenever and you want to add hourly backups, simply require jefferies_tube in your schedule.rb:

    # schedule.rb
    every :hour do
      rake 'db:backup:hourly'
    end

Or for daily backups:

    #schedule.rb
    every :day do
      rake 'db:backup:daily'
    end


### Sass

To get compass reset and box-sizing border-box to all elements

```
app/assets/stylesheets/application.sass

@import jefferies_tube
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/jefferies_tube/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
