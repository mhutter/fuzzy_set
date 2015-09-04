# FuzzySet

[![Gem Version](https://badge.fury.io/rb/fuzzy_set.svg)](http://badge.fury.io/rb/fuzzy_set)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://rubydoc.org/gems/fuzzy_set/frames)
[![Build Status](https://travis-ci.org/mhutter/fuzzy_set.svg)](https://travis-ci.org/mhutter/fuzzy_set)
[![Code Climate](https://codeclimate.com/github/mhutter/fuzzy_set/badges/gpa.svg)](https://codeclimate.com/github/mhutter/fuzzy_set)
[![Test Coverage](https://codeclimate.com/github/mhutter/fuzzy_set/badges/coverage.svg)](https://codeclimate.com/github/mhutter/fuzzy_set/coverage)


FuzzySet represents a set which allows searching its entries by using [Approximate string matching](https://en.wikipedia.org/wiki/Approximate_string_matching).

It allows you to create a fuzzy-search!

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
