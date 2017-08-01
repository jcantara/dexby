# Dexby

[![Build Status](https://travis-ci.org/jcantara/dexby.svg?branch=master)](https://travis-ci.org/jcantara/dexby)

Dexcom API wrapper for Ruby

Just so this is said right off: this software should NEVER be relied upon for medical use.
It is a toy project I am using to compile blood-glucode information for my own uses.
Please see the [MIT License](LICENSE) for specific details, but please, please never use this
for information you are trusting your life to. I would not trust my life on it and neither should you.
I am not liable for anything that should come of using this software in any way. Use at your own risk!

Additionally, I have no specific authorization from Dexcom to write this, or access their data in
this way. Their API is not advertised as public, and is used by their own apps. I am not affiliated
with Dexcom in any way and do not represent them, nor does this library.

With that out of the way, we can get to the fun stuff:

## Installation

Add this line to your application's Gemfile:

    gem 'dexby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dexby

## Usage

```ruby
require 'dexby'

dex = Dexby.new('YourDexcomUsername','dexcomPassword12345')

dex.read
```

## Contributing

1. Fork it ( https://github.com/jcantara/dexby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
