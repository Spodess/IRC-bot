require 'cinch'
require 'ruby_cowsay'
require 'open-uri'
require 'nokogiri'
require 'redis'
require 'yaml'

$nick = '';

# Load config
config = YAML.load_file("config.yaml")

# Configures $redis for persistent storage - reduces I/O, allows multiple clients to sync
x = "{ "
for i in ['port', 'host', 'password', 'path']
	# Skip the empty variables
	config['redis'][i] != "" ? x << ":#{i} => config['redis']['#{i}'], " : ""
end
x << "}"
$redis = Redis.new(eval(x))
$redis.select config['config']['database'].to_i || 1

# Hard coded admins
$botAdmins = ['Spodes', 'varzeki','adrift', 'afloat', 'joe_dirt']
m = {"user" => { "nick" => 0 } }
# Responses
responses = { 
	# General messages
	/^\s*kek\s*$/i        => 'kek',
	/^\s*ye[a]*\s*$/i     => 'YEEEE BOI',
	/^\s*whoa+\s*$/i      => 'woah*',
	/^\s*woah+\s*$/i      => 'whoa*',
	/^\s*:D+d*\s*$/       => ':DDDDD',
	/^\s*\^\s*$/          => '^',
	/^\s*wew+\s*$/i       => 'lad',
	/^\s*bot\s*$/i        => 'Hello!',
	/^\s*o\s*shit\s*$/i   => 'waddup',
	/^\s*hey guys!+\s*$/i => 'Welcome to EB Games.', # NOTE This one may never be reached
	/^\s*l[eo]+[kl]+(?<!look)\s*$/i => 'lol',
	/^\s*\?\?+\s*$/       => '? ???????????????????????????????',
	/^\s*meme\s*$/i       => 'i love memes!',
	/^\s*kk\s*$/i         => 'bb',
	/\bjames\b/i          => 'Speaking of James, that\'s Tomoko right?',
	/420/                 => 'blaze it fegit',
	/\bayy+\b/i           => 'lmao',
	/dude/i               => 'weed lmao',
	/hehe/i               => 'xd',
	/<3/                  => '<3333',
	/kekbot/              => 'hello hello',
	/help/i               => 'install gentoo',
	/navy/i               => 'What the fuck did you just fucking say about me, you little bitch?',

	# Interactive
	/^\s*fu+ck+ (y+o+)?u+/i             => "No fuck you, %s",
	/^\s*(hello|hey|hi|yo|su[ph])\s*$/i => "Hello, %s",
	/^(cya|(good)?bye)$/i               => "Cya later, %s",

	# Commands
	/^[?!.]bots\s*$/i   => "What's up fam? \x02[Ruby]\x02 | Source: https://github.com/kjensenxz/IRC-bot/blob/master/kekbot.rb",
	/^[?!.]source\s*$/i => "Source \x02[Ruby]\x02: https://github.com/kjensenxz/IRC-bot/blob/master/kekbot.rb",
	/^[?!.]tomoko\s*$/i => 'You mean James?',
	/^[?!.]acbn\s*$/i   => 'furry'
}

# Helper Functions
def findResp(hash, lookup)
	hash.each_pair do |key, value|
		return value if key =~ lookup
	end
	return nil
end

def useAdmin(m)
    return (m.channel.opped? m.user or $botAdmins.include? m.user.to_s) if m
end

def useMod(m)
    return (useAdmin(m) or m.channel.half_opped? m.user)
end

def useBot(m)
    return nil if m.params[0] == $nick
    return (useMod(m) or (m.channel.voiced? m.user and not $redis.smembers("ignored").include? m.user.to_s))
end

def useAbusive(m)
    return (useAdmin(m) or (useBot(m) and (not $redis.smembers("timed").include? m.user.to_s)))
end

def setAbusive(m)
    $redis.sadd("timed", m.user.to_s)
end

# Bot
kekbot = Cinch::Bot.new do

    # Initial Bot Config
    configure do |c|
        c.realname = config['config']['realname'] || "kekbot"
        c.server = config['config']['server']
        c.port = config['config']['port'].to_s
        c.nick = config['config']['nick'].to_s
        c.password = config['config']['password'].to_s
        c.ssl.use = config['config']['ssl']
        c.ssl.verify = false
        $nick = c.nick
        c.channels = config['config']['channels']
    end
    if config['config']['nickserv'] == "yes"
       on :connect do |m|
           User('NickServ').send("identify #{config['config']['nspassword']}")
       end
   end

    # Responsible for untiming users from abusive commands
    Timer(150) {
        for i in $redis.smembers("timed") do
            $redis.srem("timed", i)
        end
    }

    ## Responses
    on :ban do |m, ban|
        m.reply("Damn, that motherfucka just got BANNED")
    end

    on :message do |m|
        if useBot(m) #and responses.has_key?(m.message)
            x = findResp(responses, m.message)
            m.reply(x % m.user.nick) if x
        end
    end

    ## Commands

     # useBot
    on :message, /^\.fuck (.+)/i do |m, target|
        if useBot(m)
            m.channel.action("annihilates " +target  + "'s anus")
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
