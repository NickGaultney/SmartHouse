# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TasmotaConfig.create(name: "Sonoff Mini", gpio: "[32,0,0,0,160,0,0,0,224,288,0,0,0,0]")
TasmotaConfig.create(name: "Sonoff Mini Remote", gpio: "[32,0,0,0,160,0,0,0,0,224,0,0,0,0]")
TasmotaConfig.create(name: "ESP32-Inputs", gpio: "[1,1,1,1,1,1,1,1,161,160,162,1,1,1,1,1,0,1,1,1,0,1,1,1,0,0,0,0,1,1,1,1,1,0,0,1]")