## Synopsis

Kekbot is an IRC bot built using the Cinch framework.

## Installation

* Make sure you have a working redis server. If your server has a password, you will need to add it to the config.yaml AND change the kekbot.rb file to pass it to the redis statement near the top of the file
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

Currently maintained by Spodes and Varzeki.

