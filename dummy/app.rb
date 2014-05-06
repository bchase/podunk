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
    get '/'          => 'home'
    get '/jokes'     => 'all_jokes'
    get '/jokes/:id' => 'joke'
  end

  def home
    "Welcome home, #{params['name']}."
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
    "<li>#{joke.text}</li>"
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
