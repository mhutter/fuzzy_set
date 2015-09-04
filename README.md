# FuzzySet

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/fuzzy_set`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fuzzy_set'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fuzzy_set

## Usage

```ruby
require 'fuzzy_set'

states = open('states.txt').read.split(/\n/)
fs = FuzzySet.new(*states)

fs.exact_match('michigan!') # => "Michigan"
fs.exact_match('mischigen') # => nil

fs.get('mischigen')
# => ["Michigan", "Wisconsin", "Mississippi", "Minnesota", "Missouri"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mhutter/fuzzy_set.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
