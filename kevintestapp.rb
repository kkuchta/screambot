#!/usr/bin/env ruby

require 'dotenv'
require 'chatterbot/dsl'
require 'aws-sdk'
require 'pry-byebug'

Dotenv.load

polly = Aws::Polly::Client.new(
  region: 'us-west-2',
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['SECRET_ACCESS_KEY']
)
audio_file = '/Users/kevin/tmp/audio.mp3'
result = polly.synthesize_speech(
  text: 'This is a test.  This is a further test.',
  output_format: 'mp3',
  response_target: audio_file,
  voice_id: 'Brian'
)

image_file = '/Users/kevin/Desktop/images.jpg'
output_file = '/Users/kevin/tmp/out.mp4'

# Be vaaawy cawful here... we're interpolating shell commands.
command = "ffmpeg -i #{audio_file} -f image2 -loop 1 -r 25 -i #{image_file} -shortest -vcodec libx264 -acodec aac -y #{output_file}"
result = `#{command}`

# Enabling **debug_mode** prevents the bot from actually sending
# tweets. Keep this active while you are developing your bot. Once you
# are ready to send out tweets, you can remove this line.
#debug_mode

# remove this to get less output when running your bot
verbose

safelist [ENV['TARGET_ACCOUNT']]

use_streaming

home_timeline do |tweet|
  binding.pry
  puts tweet.inspect
end
