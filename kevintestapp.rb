#!/usr/bin/env ruby

require 'dotenv'
require 'chatterbot/dsl'
require 'aws-sdk'
require 'pry-byebug'
require './scream'

Dotenv.load




# Enabling **debug_mode** prevents the bot from actually sending
# tweets. Keep this active while you are developing your bot. Once you
# are ready to send out tweets, you can remove this line.
#debug_mode

# remove this to get less output when running your bot
verbose

safelist [ENV['TARGET_ACCOUNT']]

use_streaming

#def get_scream_audio(text)
  #output_file #temp
#end

home_timeline do |tweet|
  original_id = tweet.id
  name = tweet.user.screen_name
  puts "Got tweet: #{tweet.text}"
  video = Scream.new(tweet.text).make_video
  reply("@#{name}", tweet, media: File.new(video))
  puts "Posted response"
end
