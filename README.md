# JeffriesTube

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'jeffries_tube'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jeffries_tube

## Usage

### Whenever
Jefferies tube has backup functionality. To use it, add something like this to your
schedule.rb
```
every 1.day, at: '12am' do
  rake 'db:backup'
end
```

### Capistrano

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

### Sass

To get compass reset and box-sizing border-box to all elements

```
app/assets/stylesheets/application.sass

@import jeffries_tube
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/jeffries_tube/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
