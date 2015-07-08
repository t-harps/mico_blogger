require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Iniatializing MicroBlogger"
    @client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length <=140
			@client.update(message)
		else
			puts "ERROR: Tweets must be 140 characters or less, tweet length = #{message.length}"
		end
	end

  def run
  	puts "Welcome to the JSL Twitter Client!"
  	command = ""
  	while command!= "q"
  		printf "enter command: "
  		input = gets.chomp
  		parts = input.split(" ")
  		command = parts[0]
  		case command
  			when 'q' then puts "Goodbye"
  			when 't' then tweet(parts[1..-1].join(" "))
  			when 'dm' then dm(parts[1], parts[2..-1].join(" "))
  			when 'spam' then spam_my_followers(parts[1..-1].join(" "))
  			when 'elt' then everyones_last_tweet
  			else
  				puts "Sorry, only q and t are commands at the moment"
  		end
  	end
  end

  def dm(target, message)
  	screen_names = followers_list
  	puts "Trying to send #{target} this direct message: "
  	puts message
  	message = "d @#{target} #{message}"
  	if screen_names.include?(target)	
  		tweet(message)
  		puts "Sent"
  	else
  		puts "#{target} is not following you"
  	end
  end

  def followers_list
  	screen_names = @client.followers.collect{ |follower| @client.user(follower).screen_name }
  end

  def spam_my_followers(message)
  	followers = followers_list
  	followers.each do |follower|
  		dm(follower, message)
  	end
  end

  def everyones_last_tweet
  	friends = @client.friends
  	friends = friends.map { |friend| @client.user(friend) }
  	friends = friends.sort_by { |friend| friend.screen_name.downcase }
  	friends.each do |friend|
  		timestamp = friend.status.created_at
  		puts "#{friend.screen_name} tweeted the following on #{timestamp.strftime("%A, %b %d")}:"
  		puts "#{friend.status.text}"
  		puts ""
  	end
  end
end

blogger = MicroBlogger.new
blogger.run

#extraa180@yahoo.co.uk. extraa18
