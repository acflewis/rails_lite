require 'uri'

class Params
  attr_accessor :params

  def initialize(req, route_params)
    query_params = req.query_string
    body_params = req.body
    @params = {}
    @params = @params.merge(route_params)
    @params = @params.merge(parse_www_encoded_form(query_params)) unless query_params.nil?
    @params = @params.merge(parse_www_encoded_form(body_params)) unless body_params.nil?
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    all_pars = URI.decode_www_form(www_encoded_form)
    add_params = {}
    all_pars.each do |k, v|
      all_keys = parse_key(k)
      these_params = {}
      previous_key = these_params
      all_keys.each do |key|
        if key == all_keys.last
          previous_key[key] = v
          add_params = merge_recursively(add_params, these_params)
          break
        end
        previous_key[key] = {}
        previous_key = previous_key[key]
      end
    end
    add_params
  end

  def parse_key(key)
    reg = /\]\[|\[|\]/
    key.split(reg)
  end

  def merge_recursively(a, b)
    a.merge(b) {|key, a_item, b_item| merge_recursively(a_item, b_item) }
  end

end
