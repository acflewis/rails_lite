require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

server.mount_proc '/' do |req, res|
  res.status = 200
  res['content-type'] = "text/text"
  res.body = req.path
end

server.start