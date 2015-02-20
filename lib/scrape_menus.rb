require 'aws-sdk'
require 'rest_client'
require 'mini_magick'
require_relative './places'

today = Time.now.strftime('%a').downcase.to_sym
exit if today == :sat || today == :sun
credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
s3 = Aws::S3::Client.new(
  region: 'eu-central-1',
  credentials: credentials)

@places.select {|place| place.has_key?(:screenshot)}.each do |place|

  response = RestClient.get "https://api.cloudconvert.com/convert?apikey=#{ENV['CLOUDCONVERT_API_TOKEN']}&input=url&download=inline&inputformat=website&outputformat=png&file=#{CGI::escape(place[:website])}"

  coordinates = place[:screenshot][today]
  x = coordinates[0]
  y = coordinates[1]
  w = coordinates[2]
  h = coordinates[3]
  crop_params = "#{w}x#{h}+#{x}+#{y}"

  image = MiniMagick::Image.read(response)
  image.crop crop_params

  s3.put_object(
    :bucket => "planlunch",
    :key => "#{place[:id]}.png",
    :body => image.to_blob
  )
end
