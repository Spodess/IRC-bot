## Synopsis

Kekbot is an IRC bot built using the Cinch framework and [stolen from Spodes](https://github.com/Spodess/IRC-Bot).

## Installation

* Make sure you have a working redis server. If your server has a password, you will need to add it to the config.yaml.
* Install the latest version of Ruby
* Install the following gems via `gem install`:
 * `cinch`
 * `ruby_cowsay`
 * `open_uri`
 * `nokogiri`
 * `redis`
 * `yaml`
* Edit the config file so the bot joins the correct server and channel(s)
* Start the bot with `ruby kekbot.rb`

## Contributors

Currently maintained by [kjensenxz](https://github.com/kjensenxz). Previously maintained by [Spodes](https://github.com/Spodess) and [Varzeki](https://github.com/Varzeki).
