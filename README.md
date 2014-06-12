# OnlyOnce

Uses redis to ensure a ruby block only runs once for a given key in a period of time.

But if the code is run additional times, the result is read out of redis so the
subsequent calls continue to execute as if they had run the block.

One example usage might be if you have a one time use token that you exchange
for information from a 3rd party service, but for some reason you can not 
guarantee that the code that makes the token exchange will be run only once.

## Installation

Add this line to your application's Gemfile:

    gem 'only_once'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install only_once

## Usage

    result = Only.once(key) do
      # block of code that will only be run once
      # for the key

      true
    end

If the block is called more than once, the subsequent calls will wait until the
first block finishes, get the result of the first run and continue as if the
block had been executed.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
