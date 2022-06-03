# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

normal_rules = "Rule1 ON switch1#state DO Power1 %value% ENDON ON switch1#state DO Publish stat/%topic%/switch switch1:%value% ENDON"
remote_rules = "Rule1 ON switch1#state DO Publish stat/%topic%/switch switch1:%value% ENDON"

TasmotaConfig.create(name: "Sonoff Mini", gpio: "[32,0,0,0,160,0,0,0,224,288,0,0,0,0]", rules: normal_rules)
TasmotaConfig.create(name: "Sonoff Mini Remote", gpio: "[32,0,0,0,160,0,0,0,224,288,0,0,0,0]", rules: remote_rules)

Icon.create(name: "Bulb")
Icon.create(name: "Remote")
Icon.create(name: "Switch")