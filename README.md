# pendant

pendant is a small utility of accessor for Crystal.

This library is added hash-like accessor into your class.

[![travis-ci.org](https://img.shields.io/travis/MakeNowJust/pendant.svg?style=flat-square)](https://travis-ci.org/MakeNowJust/pendant)
[![docrystal.org](http://www.docrystal.org/badge.svg)](http://www.docrystal.org/github.com/MakeNowJust/pendant)
[![gratipay.com](https://img.shields.io/gratipay/MakeNowJust.svg?style=flat-square)](https://gratipay.com/MakeNowJust)
[![flattr.com](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=make_now_just&url=https%3A%2F%2Fgithub.com%2FMakeNowJust%2Fpendant)


## Installation

Add it to `Projectfile`

```crystal
deps do
  github "MakeNowJust/pendant"
end
```

## Usage

```crystal
require "pendant"

class Accessory
  # define properties and initializer
  property name, owner

  def initialize(@name, @owner); end

  # include pendant module
  # it defines `Accessory#[]`, `Accessory#[]?`, `Accessory#[]=` and
  # `Accessory#keys` automatically.
  include Pendant::Property
end

# create a new accessory
pendant = Accessory.new("pendant", "Alice")

# it can access via `[]` method
puts pendant[:name]
puts pendant["owner"]
```

## Development

```console
$ crystal spec spec/spec.cr
```

## Contributing

1. Fork it ( [https://github.com/MakeNowJust/pendant/fork](https://github.com/MakeNowJust/pendant/fork) )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [MakeNowJust](https://github.com/MakeNowJust) TSUYUSATO Kitsune - creator, maintainer
