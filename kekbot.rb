require 'cinch'
require 'ruby_cowsay'
require 'open-uri'
require 'nokogiri'
require 'redis'
require 'yaml'

#Load config
config = YAML.load_file("config.yaml")
puts config['config']['channels']
#Configures redis for persistent storage - reduces I/O, allows multiple clients to sync
redis = Redis.new(:port => config['redis']['port'])

#Hard coded admins
botAdmins = ['Spodes', 'varzeki']

#Helper Functions
def useAdmin(m)
    puts m.user.to_s
    if botAdmins.include?(m.user.to_s)
        puts "include admin"
    else
        puts "exclude admin"
    end
    return (m.channel.opped?(m.user) or botAdmins.include?(m.user.to_s))
end

def useMod(m)
    return (useAdmin(m) or m.channel.half_opped?(m.user))
end

def useBot(m)
    if not redis.smembers("ignored").include?(m.user.to_s)
        puts "not ignored"
    end
    return (useMod(m) or (m.channel.voiced?(m.user) and not redis.smembers("ignored").include?(m.user.to_s)))
end

def useAbusive(m)
    return (useAdmin(m) or (useBot(m) and (not redis.smembers("timed").include? m.user.to_s)))
end

def setAbusive(m)
    redis.sadd("timed", m.user.to_s)
end

#Bot
kekbot = Cinch::Bot.new do

    #Initial Bot Config
    configure do |c|
        c.server = config['config']['server']
        c.port = config['config']['port'].to_s
        c.nick = config['config']['nick'].to_s
        c.channels = config['config']['channels']
    end


    #Responsible for untiming users from abusive commands
    Timer(150) {
        for i in redis.smembers("timed") do
            redis.srem("timed", i)
        end
    }




    #Responses
    on :message, "ye" do |m|
        m.reply "YEEEE BOI"
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

    on :message, /^fuck you/i do |m|
        m.reply "No fuck you, #{m.user.nick}"
    end

    on :message, /^fuck u/i do |m|
        m.reply "No fuck you, #{m.user.nick}"
    end

    on :message, /james/i do |m|
        m.reply "Speaking of James, that's Tomoko right?"
    end

    on :message, /^hello$/i do |m|
        m.reply "Hello, #{m.user.nick}"
    end

    on :message, /^hey/i do |m|
        m.reply "Hello, #{m.user.nick}"
    end

    on :message, /^hi$/i do |m|
        m.reply "Hello, #{m.user.nick}"
    end

    on :message, /^yo$/i do |m|
        m.reply "Hello, #{m.user.nick}"
    end

    on :message, /^sup$/i do |m|
        m.reply "Hello, #{m.user.nick}"
    end

    on :message, /^cya$/i do |m|
        m.reply "Cya later, #{m.user.nick}"
    end

    on :message, /^bye$/i do |m|
        m.reply "Cya later, #{m.user.nick}"
    end

    on :message, /^goodbye$/i do |m|
        m.reply "Cya later, #{m.user.nick}"
    end

    on :message, /420/i do |m|
        m.reply "blaze it fegit"
    end

    on :message, /ayy/i do |m|
        m.reply "lmao"
    end

    on :message, /dude/i do |m|
        m.reply "weed"
        m.reply "lmao"
    end

    on :message, /hehe/i do |m|
        m.reply "xd"
    end

    on :message, /<3/ do |m|
        m.reply "<3333"
    end

    on :message, /kekbot/ do |m|
        m.reply "hello hello"
    end

    on :message, /help/i do |m|
        m.reply "install gentoo"
    end

    on :message, "^" do |m|
        m.reply "^"
    end

    on :message, "kek" do |m|
        m.reply "kek"
    end

    on :message, "wew" do |m|
        m.reply "lad"
    end

    on :message, "bot" do |m|
        m.reply "Hello!"
    end

    on :message, /navy/i do |m|
        m.reply "What the fuck did you just fucking say about me, you little bitch?"
    end

    on :message, "o shit" do |m|
        m.reply "waddup"
    end

    on :message, "oshit" do |m|
        m.reply "waddup"
    end

    on :message, /^hey guys!$/i do |m|
        m.reply "Welcome to EB Games."
    end

    on :message, "lok" do |m|
        m.reply "lol"
    end

    on :message, "??" do |m|
        m.reply "? ???????????????????????????????"
    end

    on :message, /^meme$/i do |m|
        m.reply "i love memes!"
    end

    on :message, "kk" do |m|
        m.reply "bb"
    end


    #Commands

    #Open
    on :message, ".bots" do |m|
        m.reply "What's up fam? \x02[Ruby]\x02 | Source: https://github.com/Spodess/IRC-bot/blob/master/kekbot.rb"
    end

    on :message, ".source" do |m|
        m.reply "Source \x02[Ruby]\x02: https://github.com/Spodess/IRC-bot/blob/master/kekbot.rb"
    end

    #useBot
    on :message, /^.fuck (.+)/ do |m, target|
        if useBot(m)
            m.channel.action("annihilates " +target  + "'s anus")
        end
    end

    on :message, ".tomoko" do |m|
        if useBot(m)
            m.reply "You mean James?"
        end
    end

    on :message, /^.rwg (.+)/ do |m, words|
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

    on :message, /^.eat (.+)/ do |m, target|
        if useBot(m)
            m.channel.action("eats ".concat(target))
        end
    end

    on :message, /^.shiton (.+)/ do |m, target|
        if useBot(m)
            m.channel.action("takes a liquidy; massive stinky shit onto ".concat(target))
        end
    end

    on :message, /^.rwb (.+)/ do |m, words|
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
    on :message, /^.cowsay (.+)/ do |m, say|
        if useAbusive(m)
            m.reply Cow.new.say(say)
            setAbusive(m.user)
        end
    end

    on :message, /^.shill (.+)/ do |m, amd|
        if useAbusive(m)
            m.reply(amd.upcase.concat("!!!"))
            m.reply(amd.upcase.concat("!!!"))
            m.reply(amd.upcase.concat("!!!"))
            setAbusive(m)
        end
    end

    on :message, /^.meme (.+)/ do |m, meme|
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
    on :message, ".reset" do |m|
        if useMod(m)
            m.channel.part()
            m.channel.join()
        end
    end

    #useAdmin
    on :message, ".pomf" do |m|
        if useAdmin(m)
            m.reply ":O C==3"
            m.reply ":OC==3"
            m.reply ":C==3"
            m.reply ":C=3"
            m.reply ":C3"
            m.reply ":3"
        end
    end

    on :message, /^.ignore (.+)/ do |m, user|
        if useAdmin(m)
            if not redis.smembers("ignored").include? user
                redis.sadd("ignored", user)
                m.reply(user.concat(" is being ignored!"))
            else
                m.reply(user.concat(" is already being ignored!"))
            end
        end
    end

    on :message, /^.unignore (.+)/ do |m, user|
        if useAdmin(m)
            if redis.smembers("ignored").include? user
                redis.srem("ignored", user)
                m.reply(user.concat(" is no longer being ignored!"))
            else
                m.reply(user.concat(" wasn't on the ignore list!"))
            end
        end
    end
end

#Set logging
kekbot.loggers << Cinch::Logger::FormattedLogger.new(File.open("./kekbot.log", "a"))
kekbot.loggers.level = :debug
kekbot.loggers.first.level = :info

#Start
kekbot.start
