require 'em-websocket'

PORT = (ARGV.shift || 8080).to_i

EM::run do

  puts "start websocket server - port:#{PORT}"
  @channel = EM::Channel.new

  EM::WebSocket.start(:host => '0.0.0.0', :port => PORT) do |ws|
    ws.onopen do
      sid = @channel.subscribe do |mes|
        ws.send(mes)
      end
      puts "<#{sid}> connected!!"

      ws.onmessage do |clicked_point_json|
        puts "<#{sid}> #{clicked_point_json}"
        @channel.push(clicked_point_json)
      end

      ws.onclose do
      end
    end
  end
end
