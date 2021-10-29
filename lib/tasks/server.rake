desc 'Stop rails server'
task :stop do
  File.new("tmp/pids/server.pid").tap { |f| `kill -9 #{f.read.to_i}` }
  File.new("tmp/pids/mqtt.pid").tap { |f| `kill -9 #{f.read.to_i}` }
end

desc 'Starts rails server'
task :start do
  Process.spawn("rake wtmqtt:subscribe")
  Process.exec("rails s -b 0.0.0.0 -d")
end

desc "Restarts rails server"
task :restart do
  Rake::Task[:stop].invoke
  Rake::Task[:start].invoke
end