require 'pp'

class ShowHttpHeadersApp
  def call(env)
    response = env.pretty_inspect
    [200, {'Content-Type' => 'plain/text'}, [response]]
  end
end

run ShowHttpHeadersApp.new
