class Scream
  AUDIO_FILE_LOCATION = '/tmp/scream_audio.mp3'
  IMAGE_FILE_LOCATION = './scream.jpg'
  OUTPUT_FILE_LOCATION = '/tmp/scream_video.mp4'

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

  private

  def make_audio
    self.class.polly.synthesize_speech(
      text: ssml,
      text_type: 'ssml',
      output_format: 'mp3',
      response_target: AUDIO_FILE_LOCATION,
      voice_id: voice_ids.sample
    )
    AUDIO_FILE_LOCATION
  end

  def ssml
    a_sub = ['ə','æ','ɑ'].sample
    subbed_text = @text.gsub(/[aA]/, a_sub)

    puts "Made #{subbed_text}"
    "
      <speak> <phoneme alphabet='ipa' ph='#{subbed_text}'></phoneme> </speak>
    ".strip
  end

  def voice_ids
    @voice_ids ||= self.class.polly.describe_voices.voices.map(&:id)
  end
end
