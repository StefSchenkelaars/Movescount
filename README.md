# Movescount

A gem for communicating with the [Suunto movescount](http://www.movescount.com/) API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'movescount'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install movescount

## Configuration

You can use a configure block to setup the gem and provide the `app_key`

```ruby
Movescount.configure do |config|
  config.app_key = 'TestAppKey'
  config.api_uri = 'https://uiservices.movescount.com'
end
```

## Usage

It all starts with a movescount member object

```ruby
Movescount::Member.new(email: 'foo@bar.com', userkey: 'ABCDEFGHIJKLMNO')
```

This `userkey` is an extra check if the requests are from the same origin. When you change the `userkey`, the user has to reconfirm the integration in movescount. So make sure you save this (user specific) key.

TODO: More and don't forget the nice rails concerns

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/StefSchenkelaars/movescount.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Ideas from

https://robots.thoughtbot.com/mygem-configure-block
