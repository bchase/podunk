require 'podunk'

class Application < Podunk::App
  class Joke
    @@jokes = []

    attr_accessor :text, :source
    def initialize(text, source)
      @text, @source = text, source

      @@jokes << self
    end

    def id
      object_id
    end

    def self.find(id)
      all.find {|joke| joke.id == id}
    end

    def self.all
      @@jokes
    end
  end

  Joke.new "A book just fell on my head... I only have my shelf to blame.", "Ellie (TLOU)"
  Joke.new "Bakers trade bread recipes on a knead-to-know basis.", "Ellie (TLOU)"

  route do
    root to: 'home'

    get '/jokes'     => 'all_jokes'
    get '/jokes/:id' => 'joke'
  end

  def home
    "<p>Welcome home, #{params['name']}.</p>"
  end

  def all_jokes
    @jokes = Joke.all
    jokes_ul
  end
  
  def joke
    @joke = Joke.find params[:id]
    joke_div
  end

private
  def jokes_ul
    ul  = "<ul>"

    @jokes.each do |joke|
      ul += joke_li(joke)
    end

    ul += "</ul>" 
  end

  def joke_li(joke)
    "<li>#{link_to joke.text, joke_path(joke)}</li>"
  end

  def link_to(text, href)
    "<a href=\"#{href}\">#{text}</a>"
  end

  def joke_path(joke)
    joke_id = joke.is_a?(Fixnum) ? joke : joke.id
    "/jokes/#{joke_id}"
  end

  def joke_div
    "<div>"  +
      dl('text', @joke.text) +
      dl('source', @joke.source) +
    "</div>"
  end

  def dl(term, description)
    "<dl>" +
    "  <dt>#{term}</dt>" +
    "  <dd>#{description}</dd>" +
    "</dl>"
  end
end
