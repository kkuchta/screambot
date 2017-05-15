# Screambot

When AWS added support for whispering to it's "Amazon Polly" speech synthesizer, a friend tweeted "Whispering is all well and good, but I want a “hysterical screaming” option too."  Of course at that point, I couldn't _not_ build a synthesized screambot.

@thescreambot listens for posts from @infinite_scream.  Whenever it gets one it:
  1. Grabs the text of the tweet
  2. Replaces all the `a`s with International Phonetic Alphabet symbols (eg `æ`)
  3. Generates an audio file with Amazon Polly (using phoneme pronunciation to prevent it from just always saying `ah`)
  4. Uses `ffmpeg` to combine a jpg and the audio file into a relatively boring video
  5. Posts the result as a reply to @infinite_scream.

I probably won't maintain this repo, so here are some notes if, for some reason, you want to use it:

## Dependencies be crazy
So, the latest version of the twitter ruby sdk (6.1.0) doesn't support the latest version of twitter's api entirely.  Specifically, video upload doesn't work.  Someone fixed this on a rejected PR (https://github.com/sferik/twitter/pull/824), so I set that PR's commit as the `twitter` gem version in the Gemfile.  It's hacky ask hell, but it was the only way I could get video upload to work without doing the http requests by hand.

I also forked `chatterbot`, the basis for this repo, to not specify a specific version of the twitter gem (so I could get away with using the janky, in-development version).

## You'll need ffmpeg
This bot uses the ffmpeg cli tool.  If, like me, you want to deploy this to heroku, you can use ` heroku buildpacks:add https://github.com/jonathanong/heroku-buildpack-ffmpeg-latest.git`

## Setup
```
gem install chatterbot
chatterbot-register
```

## Running
bundle exec screambot.rb
