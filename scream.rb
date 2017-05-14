class Scream
  AUDIO_FILE_LOCATION = '/Users/kevin/tmp/audio.mp3'
  IMAGE_FILE_LOCATION = './scream.jpg'
  OUTPUT_FILE_LOCATION = '/Users/kevin/tmp/out.mp4'

  def self.polly
    @polly ||= Aws::Polly::Client.new(
      region: 'us-west-2',
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['SECRET_ACCESS_KEY']
    )
  end
    
  def initialize(text)
    @text = text
  end

  def make_video
    audio_file = make_audio
    # Be vaaawy cawful here... we're interpolating shell commands.
    command = "ffmpeg -i #{audio_file} -f image2 -loop 1 -r 25 -i #{IMAGE_FILE_LOCATION} -shortest -vcodec libx264 -pix_fmt yuv420p -acodec aac -y -profile:v baseline #{OUTPUT_FILE_LOCATION}"
    result = `#{command}`
    OUTPUT_FILE_LOCATION
  end

  def make_audio
    self.class.polly.synthesize_speech(
      text: @text,
      output_format: 'mp3',
      response_target: AUDIO_FILE_LOCATION,
      voice_id: 'Brian'
    )
    AUDIO_FILE_LOCATION
  end

end
