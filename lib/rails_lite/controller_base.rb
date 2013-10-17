require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'
require 'json'

class ControllerBase
  attr_reader :params
  attr_accessor :already_built_response, :res, :req, :session

  def initialize(req, res, route_params)
    @req = req
    @res = res
    @params = Params.new(req, route_params)
    @already_built_response = false
    session
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    @already_built_response
  end

  def redirect_to(url)
   unless already_rendered?
    @res.status = 302
    @res['location'] = url
    @already_built_response = true
    @session.store_session(@res)
   end
  end

  def render_content(content, type)
    unless already_rendered?
      @res.content_type = type
      @res.body = content
      @already_built_response = true
      @session.store_session(@res)
    end
  end

  def render(template_name)
    controller_us = self.class.to_s.underscore
    filename = "views/#{controller_us}/#{template_name}.html.erb"
    contents = File.read(filename)
    content = ERB.new(contents).result(binding)
    render_content(content, 'text/text')
  end

  def invoke_action(name)
    #use send to call the appropriate action (like index or show)
    send(name)
    #check to see if a template was rendered; if not call render in invoke_action.
    render(name) unless already_rendered?
  end
end
