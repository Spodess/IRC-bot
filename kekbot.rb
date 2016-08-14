require 'cinch'
require 'ruby_cowsay'
require 'open-uri'
require 'nokogiri'
require 'redis'

redis = Redis.new(:port => 6379)

kekbot = Cinch::Bot.new do
    configure do |c|
    c.server = "irc.rizon.net"
	c.port = "7000"
	c.nick = "kekbot"
	c.channels = ["#homescreen"]
    end

	 Timer(150) { 
	 for i in redis.smembers("timed") do
		redis.srem("timed", i)
	 end     }
	
    on :message, /^.g (.+)/ do |m, query|
        begin
            search_l = query.split(" ")
	    search = search_l.join("+")
	    srch_pg = Nokogiri::HTML(open('http://www.google.com/search?q='.concat(search)))
	    out = "Result for #{query}:\n"
	    link = srch_pg.css('h3 a')[0]['href']
	    7.times { link[0] = "" }
	    link_splt = link.split("&sa")
	    out.concat(link_splt.first)
	    m.reply(out)
	rescue
	    m.reply("No results found!")
	end
    end

    on :message, "ye" do |m|
        m.reply "YE YE YE"
    end
    
	    on :message, "Kek" do |m|
        m.reply "kek"
    end
	
	on :message, "woah" do |m|
        m.reply "whoa*"
    end
	
	on :message, ".acbn" do |m|
        m.reply "furry"
    end
	
	on :message, ":D" do |m|
        m.reply ":DDDD"
    end
	
	on :message, ".tomoko" do |m|
        m.reply "You mean James?"
    end
	
	on :message, ".bots" do |m|
        m.reply "What's up fam? | Source: https://github.com/Spodess/IRC-bot/blob/master/kekbot.rb"
    end
	
	on :message, ".source" do |m|
        m.reply "Source: https://github.com/Spodess/IRC-bot/blob/master/kekbot.rb"
    end
	
	on :message, /[4][2][0]/ do |m|
        m.reply "blaze it fegit"
    end
	
	on :message, /[Aa][Yy][Yy]/ do |m|
        m.reply "lmao"
    end
	
	on :message, /[Dd][Uu][Dd][Ee]/ do |m|
        m.reply "weed"
		m.reply "lmao"
    end
	
	on :message, /[Hh][Ee][Hh][Ee]/ do |m|
        m.reply "xd"
    end
	
	on :message, /[<3]/ do |m|
        m.reply "<3333"
    end
	
	on :message, /[Kk][Ee][Kk][Bb][Oo][Tt]/ do |m|
        m.reply "hello hello"
    end
	
	on :message, /[Hh][Ee][Ll][Pp]/ do |m|
        m.reply "install gentoo"
    end
	
	on :message, "^" do |m|
        m.reply "^"
    end
	
	on :message, "kek" do |m|
        m.reply "kek"
    end
	
	on :message, "lol" do |m|
        m.reply "lol"
    end
	on :message, "wew" do |m|
        m.reply "lad"
    end
	
	on :message, "bot" do |m|
        m.reply "Hello!"
    end
	
    on :message, ".pomf" do |m|
        m.reply ":O C==3"
        m.reply ":OC==3"
        m.reply ":C==3"
        m.reply ":C=3"
        m.reply ":C3"
        m.reply ":3"
    end

    on :message, /[Nn][Aa][Vv][Yy]/ do |m|
        m.reply "What the fuck did you just fucking say about me, you little bitch?"
    end

    on :message, "linux" do |m|
        if rand(5) == 1
            m.reply "I'd just like to interject for a moment."
	    m.reply "What you’re referring to as Linux, is in fact, GNU/Linux, or as I’ve recently taken to calling it, GNU + Linux."
	end
    end

    on :message, "o shit" do |m|
        m.reply "waddup"
    end

	on :message, "oshit" do |m|
        m.reply "waddup"
    end

	on :message, "Hey guys!" do |m|
        m.reply "Welcome to EB Games."
    end
	
	on :message, "Hey guys" do |m|
        m.reply "Welcome to EB Games."
    end
	
	on :message, "hey guys" do |m|
        m.reply "Welcome to EB Games."
    end
	
    on :message, "lok" do |m|
        m.reply "lol"
    end
	
    on :message, "??" do |m|
        m.reply "? ???????????????????????????????"
    end

    on :message, "meme" do |m|
        m.reply "i love memes!"
    end
	
     on :message, "kk" do |m|
        m.reply "bb"
    end
	
    on :message, /^.eat (.+)/ do |m, target|
        m.channel.action("eats ".concat(target))
    end

	on :message, /^.shiton (.+)/ do |m, target|
        m.channel.action("takes a liquidy; massive stinky shit onto ".concat(target))
    end
	
	on :message, /^.fuck (.+)/ do |m, target|
        m.channel.action("annihilates " +target  + "'s anus")
    end
	
    on :message, /^.rwb (.+)/ do |m, words|
        out = ""
	col = 0
	w_arr = words.split(" ")
	w_arr.each do |word|
	    if col == 0
	        out.concat(Format(:red, word).concat(" "))
	    end

	    if col == 1 
	        out.concat(Format(:white, word).concat(" "))
	    end

	    if col == 2
	        out.concat(Format(:blue, word).concat(" "))
		col = 0
	    else
	        col = col + 1
	    end
        end
	m.reply(out)
    end

    on :message, /^.rwg (.+)/ do |m, words|
        out = ""
	col = 0
	w_arr = words.split(" ")
	w_arr.each do |word|
	    if col == 0
	        out.concat(Format(:red, word).concat(" "))
	    end

	    if col == 1 
	        out.concat(Format(:white, word).concat(" "))
	    end

	    if col == 2
	        out.concat(Format(:green, word).concat(" "))
		col = 0
	    else
	        col = col + 1
	    end
        end
	m.reply(out)
    end
	
    on :message, /^.meme (.+)/ do |m, meme|
        timed = redis.smembers("timed")
        user = m.user.to_s
        if not(timed.include? user)
            meme_list = meme.split(//)
            meme_spaced = meme_list.join(" ")
            m.reply(meme_spaced)
            for i in 1..10 do
                m.reply(meme[i])
            end
            redis.sadd("timed", m.user)
        else
            m.reply("You are timed out!")
        end
    end
	
    on :message, /^.shill (.+)/ do |m, amd|
        m.reply(amd.upcase.concat("!!!"))
        m.reply(amd.upcase.concat("!!!"))
        m.reply(amd.upcase.concat("!!!"))
    end

end

kekbot.start
