class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    pat = @pattern
    @http_method == req.request_method.downcase.to_sym && !@pattern.match(req.path).nil?
  end

  def run(req, res)
    match_data = @pattern.match(req.path)

    names = match_data.names
    captures = match_data.captures

    router_params = {}
    names.each_with_index do |name, index|
      router_params[name.to_sym] = captures[index]
    end

    @controller_class.new(req,res, router_params).invoke_action(@action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    # add these helpers in a loop here
    define_method(http_method) { |pattern, controller_class, action_name|
      #Pattern should be a regexp. Use ^ and $ to match the beginning/end of the string.
      add_route(pattern, http_method, controller_class, action_name)
    }
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end
    nil
  end

  def run(req, res)
    matching_route = match(req)
    if matching_route.nil?
      res.status = 404
    else
      matching_route.run(req, res)
    end
  end
end
