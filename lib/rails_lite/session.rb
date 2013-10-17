require 'json'
require 'webrick'

class Session

  attr_accessor :cookie_val

  def initialize(req)
    all_cookies = req.cookies
    @cookie = {}
    all_cookies.each do |cookie|
     @cookie = JSON.parse(cookie.value) if cookie.name == ('_rails_lite_app')
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, value)
    @cookie[key] = value
  end

  def store_session(res)
    # make a new cookie named '_rails_lite_app'
    # set the value to the JSON serialized content of the hash
    # add this cookie to response.cookies.
    cookie = WEBrick::Cookie.new("_rails_lite_app", JSON.dump(@cookie))
    res.cookies << cookie
  end
end
