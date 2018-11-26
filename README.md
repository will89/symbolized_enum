# SymbolizedEnum

[![Gem Version](https://badge.fury.io/rb/symbolized_enum.svg)][gem]
[![Build Status](https://travis-ci.com/will89/symbolized_enum.svg?branch=master)][travis]

[gem]: https://rubygems.org/gems/symbolized_enum
[travis]: http://travis-ci.com/will89/symbolized_enum

Provides a convenient interface to using an activerecord attribute as a symbol and using validates_inclusion_of with symbols.
Optionally, can generate predicate methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'symbolized_enum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install symbolized_enum

## Usage

```ruby
require 'symbolized_enum'

class Post < ApplicationRecord
  include SymbolizedEnum

  # A database column 'post_type' can be used as a symbolized enumeration by:
  symbolized_enum :post_type, in: [:informative, :rant]
end

# Optional predicate methods
class Post < ApplicationRecord
  include SymbolizedEnum

  # A database column 'post_type' can be used as a symbolized enumeration by:
  symbolized_enum :post_type, predicates: true, in: [:informative, :rant]
end

post = Post.new(post_type: :informative)
post.informative?
=> true

# Predicate methods prefixed by attribute name
class Post < ApplicationRecord
  include SymbolizedEnum

  # A database column 'post_type' can be used as a symbolized enumeration by:
  symbolized_enum :post_type, predicates: true, prefixed_predicate: true, in: [:informative, :rant]
end

post = Post.new(post_type: :informative)
post.post_type_informative?
=> true

# Predicate methods suffixed by attribute name
class Post < ApplicationRecord
  include SymbolizedEnum

  # A database column 'post_type' can be used as a symbolized enumeration by:
  symbolized_enum :post_type, predicates: true, suffixed_predicate: true, in: [:informative, :rant]
end

post = Post.new(post_type: :informative)
post.informative_post_type?
=> true

# Predicate methods generated by proc
class Post < ApplicationRecord
  include SymbolizedEnum

  # A database column 'post_type' can be used as a symbolized enumeration by:
  symbolized_enum :post_type, predicates: true, predicate_name_generator: proc { |attr_name, enum_value| "customizable_#{enum_value}_#{attr_name}?" }, in: [:informative, :rant]
end

post = Post.new(post_type: :informative)
post.customizable_informative_post_type?
=> true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[will89]/symbolized_enum. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SymbolizedEnum project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[will89]/symbolized_enum/blob/master/CODE_OF_CONDUCT.md).
