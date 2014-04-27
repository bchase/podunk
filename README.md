# Podunk

A tiny web framework on top of Rack

## Installation

Add this line to your application's Gemfile:

    gem 'podunk', github: 'bchase/podunk'

And then execute:

    $ bundle

## Limitations

You'll be interested to learn that, at the moment, Podunk is almost entirely comprised of limitations.

Inside, you'll find:

1. rudimentary query string parameter parsing
2. simple routing for `GET` requests (all right!)
3. thrilling plaintext body

## Usage

```ruby
### app.rb ###

class Application < Podunk::App
  route do
    get '/' => 'home'
  end

  def home
    "Welcome home, #{params['name']}."
  end
end
```

```ruby
### config.ru ###

require './app.rb'

run Application.new
```

```bash
$ rackup                         
```

```bash
$ curl "localhost:9292?name=Bud" 
Welcome home, Bud.%  
```
