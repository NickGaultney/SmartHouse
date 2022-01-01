desc 'Stop rails server'
task :stop do
  begin
    File.new("tmp/pids/server.pid").tap { |f| `kill -9 #{f.read.to_i}` }
  rescue
  end

  begin
    File.new("tmp/pids/mqtt.pid").tap { |f| `kill -9 #{f.read.to_i}` }
  rescue
  end
end

desc 'Starts both servers'
task :start do
  system("screen -dmS mqtt rake wtmqtt:subscribe")
  system("screen -dmS rails rails s -b 0.0.0.0")
  system("screen -dmS sidekiq bundle exec sidekiq")
end

desc 'Starts rails servers'
task :rs do
  Process.exec("rails s -b 0.0.0.0 -d")
end

desc 'Starts mqtt servers'
task :ms do
  Process.spawn("nohup rake wtmqtt:subscribe &")
end

desc 'Starts mqtt server and listen'
task :mlisten do
  Process.exec("rails s -b 0.0.0.0 -d")
  Process.spawn("rake wtmqtt:subscribe")
end

desc 'Starts rails server and listen'
task :rlisten do
  Process.spawn("nohup rake wtmqtt:subscribe &")
  Process.exec("rails s -b 0.0.0.0")
end

desc "Restarts rails server"
task :restart do
  Rake::Task[:stop].invoke
  Rake::Task[:start].invoke
end

desc "Restarts rails server"
task :restart_mqtt do
  File.new("tmp/pids/mqtt.pid").tap { |f| `kill -9 #{f.read.to_i}` }
  Process.spawn("nohup rake wtmqtt:subscribe &")
end

desc "Flash Sonoff Device with Tasmota Firmware"
task :flash, [:ip] do
  HTTP.post("http://#{args[:ip]}:8081/zeroconf/info", json: {deviceid: "", data: {}})
  HTTP.post("http://#{args[:ip]}:8081/zeroconf/ota_unlock", json: {deviceid: "", data: {}})
  HTTP.post("http://#{args[:ip]}:8081/zeroconf/ota_flash", json: {deviceid: "", data: { downloadUrl: "http://sonoff-ota.aelius.com/tasmota-latest-lite.bin", sha256sum: "d6bf5fbb135c79cbf8ef3167bc2094b13b4e850377c713219fcd18854d7ba10c"} })
end
