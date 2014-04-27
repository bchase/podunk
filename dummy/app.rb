require 'podunk'

class Application < Podunk::App
  route do
    get '/' => 'home'
  end

  def home
    "Welcome home, #{params['name']}."
  end
end
