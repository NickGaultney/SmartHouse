desc 'Stop rails server'
task :stop do
  begin
    system("screen -X -S rails quit")
  rescue
  end

  begin
    system("screen -X -S mqtt quit")
  rescue
  end

  begin
    system("screen -X -S sidekiq quit")
  rescue
  end

  begin
    system("screen -X -S scheduler quit")
  rescue
  end
end

desc 'Starts both servers'
task :start do
  system("screen -dmS mqtt rake wtmqtt:subscribe")
  system("screen -dmS rails rails s -b 0.0.0.0")
  system("screen -dmS sidekiq bundle exec sidekiq")
  system("screen -dmS scheduler rake scheduler")
end

desc "Restarts rails server"
task :restart do
  Rake::Task[:stop].invoke
  Rake::Task[:start].invoke
end

desc "Launch mosquitto client"
task :debug_mqtt do
  system("screen -S debug mosquitto_sub -h localhost -p 1883 -u homeiot -P 12345678 -t '#' -v")
end

desc "Flash Sonoff Device with Tasmota Firmware"
task :flash, [:ip] do
  HTTP.post("http://#{args[:ip]}:8081/zeroconf/info", json: {deviceid: "", data: {}})
  HTTP.post("http://#{args[:ip]}:8081/zeroconf/ota_unlock", json: {deviceid: "", data: {}})
  HTTP.post("http://#{args[:ip]}:8081/zeroconf/ota_flash", json: {deviceid: "", data: { downloadUrl: "http://sonoff-ota.aelius.com/tasmota-latest-lite.bin", sha256sum: "d6bf5fbb135c79cbf8ef3167bc2094b13b4e850377c713219fcd18854d7ba10c"} })
end
