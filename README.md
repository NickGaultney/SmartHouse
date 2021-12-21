# README

Installation Process:

Connect to Wi-Fi: https://ubuntu.com/core/docs/networkmanager/configure-wifi-connections
1) Plug in ethernet cable
2) sudo apt update
3) sudo apt install network-manager
4) nmcli d wifi list
5) nmcli d wifi connect my_wifi password <password>

Install rails: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-20-04
1) sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
2) curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
3) echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
3.5) echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
4) echo 'eval "$(rbenv init -)"' >> ~/.bashrc
4.5) echo 'eval "$(rbenv init -)"' >> ~/.profile
4.6) export MQTT_USERNAME="homeiot"
4.7) export MQTT_PASSWORD="12345678"
4.8) export MQTT_HOST=""
5) source ~/.bashrc
6) git clone https://github.com/rbenv/ruby-build.git
7) PREFIX=/usr/local sudo ./ruby-build/install.sh
8) rbenv install 2.7.0
9) rbenv global 2.7.0
10) ruby -v
11) echo "gem: --no-document" > ~/.gemrc
12) gem install bundler
13) gem install rails -v 5.2.4.4
14) rails -v
14.5) sudo apt install sqlite3
15) git clone https://github.com/NickGaultney/SmartHouse.git
16) cd SmartHouse
17) bundle install
18) curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
19) sudo apt install -y nodejs
20) sudo apt install mosquitto
