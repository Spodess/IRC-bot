require 'cinch'
require 'ruby_cowsay'
require 'open-uri'
require 'nokogiri'
require 'redis'
require 'yaml'

#Load config
config = YAML.load_file("config.yaml")

#Configures $redis for persistent storage - reduces I/O, allows multiple clients to sync
x = "{"
for i in ['port', 'host', 'password', 'path']
	# Skip the empty variables
	config['redis'][i] != "" ? x << ":#{i} => config['redis']['#{i}'], " : ""
end
x << "}"
print x, eval(x)
$redis = Redis.new(eval(x))

#Hard coded admins
$botAdmins = ['Spodes', 'varzeki', 'adrift', 'afloat', 'joe_dirt']

#Helper Functions
def useAdmin(m)
    return (m.channel.opped?(m.user) or $botAdmins.include? m.user.to_s)
end

def useMod(m)
    return (useAdmin(m) or m.channel.half_opped? m.user)
end

def useBot(m)
    return (useMod(m) or (m.channel.voiced? m.user and not $redis.smembers("ignored").include? m.user.to_s))
end

def useAbusive(m)
    return (useAdmin(m) or (useBot(m) and (not $redis.smembers("timed").include? m.user.to_s)))
end

def setAbusive(m)
    $redis.sadd("timed", m.user.to_s)
end

#Bot
kekbot = Cinch::Bot.new do

    #Initial Bot Config
    configure do |c|
        c.realname = config['config']['realname'] || "kekbot"
        c.server = config['config']['server']
        c.port = config['config']['port'].to_s
        c.nick = config['config']['nick'].to_s
        c.channels = config['config']['channels']
    end

    on :connect do |m|
        User('NickServ').send("identify #{config['config']['password']}")
    end

    #Responsible for untiming users from abusive commands
    Timer(150) {
        for i in $redis.smembers("timed") do
            $redis.srem("timed", i)
        end
    }

    #Responses
    on :ban do |m, ban|
        m.reply("Damn, that motherfucka just got BANNED")
    end

    on :message, /^\s*ye[a]{0,1}\s*$/i do |m|
        if useBot(m)
            m.reply "YEEEE BOI"
        end
    end

    on :message, /^\s*kek\s*$/i do |m|
        if useBot(m)
            m.reply "kek"
        end
    end

    on :message, /^\s*woah+\s*$/ do |m|
        if useBot(m)
            m.reply "whoa*"
        end
    end

    on :message, /^\s*whoa+\s*$/ do |m|
        if useBot(m)
            m.reply "woah*"
        end
    end

    on :message, /^\s*:D+d*\s*$/ do |m|
        if useBot(m)
            m.reply ":DDDD"
        end
    end

    on :message, /^\s*fu+ck+ (y+o+)?u+/i do |m|
        if useBot(m)
            m.reply "No fuck you, #{m.user.nick}"
        end
    end

    on :message, /james/i do |m|
        if useBot(m)
            m.reply "Speaking of James, that's Tomoko right?"
        end
    end

    on :message, /^\s*(hello|hey|hi|yo|su[ph])\s*$/i do |m|
        if useBot(m)
            m.reply "Hello, #{m.user.nick}"
        end
    end

    on :message, /^(cya|(good)?bye)$/i do |m|
        if useBot(m)
            m.reply "Cya later, #{m.user.nick}"
        end
    end

    on :message, /420/i do |m|
        if useBot(m)
            m.reply "blaze it fegit"
        end
    end

    on :message, /ayy/i do |m|
        if useBot(m)
            m.reply "lmao"
        end
    end

    on :message, /dude/i do |m|
        if useBot(m)
            m.reply "weed"
            m.reply "lmao"
        end
    end

    on :message, /hehe/i do |m|
        if useBot(m)
            m.reply "xd"
        end
    end

    on :message, /<3/ do |m|
        if useBot(m)
            m.reply "<3333"
        end
    end

    on :message, /kekbot/ do |m|
        if useBot(m)
            m.reply "hello hello"
        end
    end

    on :message, /help/i do |m|
        if useBot(m)
            m.reply "install gentoo"
        end
    end

    on :message, /^\s*\^\s*$/ do |m|
        if useBot(m)
            m.reply "^"
        end
    end

    on :message, /^\s*wew+\s*$/i do |m|
        if useBot(m)
            m.reply "lad"
        end
    end

    on :message, /^\s*bot\s*$/i do |m|
        if useBot(m)
            m.reply "Hello!"
        end
    end

    on :message, /navy/i do |m|
        if useBot(m)
            m.reply "What the fuck did you just fucking say about me, you little bitch?"
        end
    end

    on :message, /^\s*o\s*shit\s*/ do |m|
        if useBot(m)
            m.reply "waddup"
        end
    end

    on :message, /^hey guys!\s*$/i do |m|
        if useBot(m)
            m.reply "Welcome to EB Games."
        end
    end

    on :message, /^\s*l[eo]+[kl]+(?<!look)\s*$/i do |m|
        if useBot(m)
            m.reply "lol"
        end
    end

    on :message, /^\s*\?\?+\s*/ do |m|
        if useBot(m)
            m.reply "? ???????????????????????????????"
        end
    end

    on :message, /^meme$/i do |m|
        if useBot(m)
            m.reply "i love memes!"
        end
    end

    on :message, "kk" do |m|
        if useBot(m)
            m.reply "bb"
        end
    end

    #Commands

    #Open
    on :message, /^\.bots\s*$/i do |m|
        m.reply "What's up fam? \x02[Ruby]\x02 | Source: https://github.com/Spodess/IRC-bot/blob/master/kekbot.rb"
    end

    on :message, /^\.source\s*$/i do |m|
        m.reply "Source \x02[Ruby]\x02: https://github.com/Spodess/IRC-bot/blob/master/kekbot.rb"
    end

    #useBot
    on :message, /^\.fuck (.+)/i do |m, target|
        if useBot(m)
            m.channel.action("annihilates " +target  + "'s anus")
        end
    end

    on :message, /^\.tomoko\s*$/i do |m|
        if useBot(m)
            m.reply "You mean James?"
        end
    end

    on :message, /^\.rwg (.+)/i do |m, words|
        if useBot(m)
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
    end

    on :message, /^\.acbn\s*$/i do |m|
        if useBot(m)
            m.reply "furry"
        end
    end

    on :message, /^.eat (.+)/i do |m, target|
        if useBot(m)
            m.channel.action("eats ".concat(target))
        end
    end

    on :message, /^\.shiton (.+)/i do |m, target|
        if useBot(m)
            m.channel.action("takes a liquidy; massive stinky shit onto ".concat(target))
        end
    end

    on :message, /^\.rwb (.+)/i do |m, words|
        if useBot(m)
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
    end

    #useAbusive
    on :message, /^\.cowsay (.+)/i do |m, say|
        if useAbusive(m)
            m.reply Cow.new.say(say)
            setAbusive(m.user)
        end
    end

    on :message, /^\.shill (.+)/i do |m, amd|
        if useAbusive(m)
            m.reply(amd.upcase.concat("!!!"))
            m.reply(amd.upcase.concat("!!!"))
            m.reply(amd.upcase.concat("!!!"))
            setAbusive(m)
        end
    end

    on :message, /^\.meme (.+)/i do |m, meme|
        if useAbusive(m)
            meme_list = meme.split(//)
            meme_spaced = meme_list.join(" ")
            m.reply(meme_spaced)
            for i in 1..10 do
                m.reply(meme[i])
            end
            setAbusive(m)
        end
    end

    #useMod
    on :message, /^\.reset\s*$/i do |m|
        if useMod(m)
            m.channel.part()
            m.channel.join()
        end
    end

    #useAdmin
    on :message, /^\.pomf\s*$/i do |m|
        if useAdmin(m)
            m.reply ":O C==3"
            m.reply ":OC==3"
            m.reply ":C==3"
            m.reply ":C=3"
            m.reply ":C3"
            m.reply ":3"
        end
    end

    on :message, /^\.ignore (.+)/i do |m, user|
        if useAdmin(m)
            user.strip!
            if not $redis.smembers("ignored").include? user
                $redis.sadd("ignored", user)
                m.reply(user.concat(" is being ignored!"))
            else
                m.reply(user.concat(" is already being ignored!"))
            end
        end
    end

    on :message, /^\.unignore (.+)/i do |m, user|
        if useAdmin(m)
            user.strip!
            if $redis.smembers("ignored").include? user
                $redis.srem("ignored", user)
                m.reply(user.concat(" is no longer being ignored!"))
            else
                m.reply(user.concat(" wasn't on the ignore list!"))
            end
        end
    end

    on :message, /^\.ignored\s*$/i do |m|
        if useAdmin(m)
            lst = $redis.smembers("ignored")
            out = ""
            lst.each {|i| out.concat(i).concat(" ")}
            m.reply(out)
        end
    end
end

#Set logging
kekbot.loggers << Cinch::Logger::FormattedLogger.new(File.open("./kekbot.log", "a"))
kekbot.loggers.level = :debug
kekbot.loggers.first.level = :info

#Start
kekbot.start
