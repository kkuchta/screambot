#!/usr/bin/env ruby

require 'chatterbot/dsl'
require 'aws-sdk'

# Dev-only reqs
unless ENV['TARGET_ACCOUNT']
  require 'pry-byebug'
  require 'dotenv'
  Dotenv.load
end

require './scream'

# remove this to get less output when running your bot
verbose
safelist [ENV['TARGET_ACCOUNT']]
use_streaming

home_timeline do |tweet|
  original_id = tweet.id
  name = tweet.user.screen_name
  puts "Got tweet: #{tweet.text}"
  video = Scream.new(tweet.text).make_video
  reply("@#{name}", tweet, media: File.new(video))
  puts "Posted response"
end
