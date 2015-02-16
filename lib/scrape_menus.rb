require 'rest_client'
require 'mini_magick'
require_relative './places'

today = Time.now.strftime('%a').downcase.to_sym
exit if today == :sat || today == :sun

@places.select {|place| place.has_key?(:screenshot)}.each do |place|

  response = RestClient.get "https://api.cloudconvert.com/convert?apikey=C7k5tfpSmYOzqnQCmiKhL2m7IS4X8J6BJEob12eRhnC576vGWCeQ8jU53j7L9bzRlnzt6DSVALdS1FV3jwCm2Q&input=url&download=inline&inputformat=website&outputformat=png&file=#{CGI::escape(place[:website])}"

  coordinates = place[:screenshot][today]
  x = coordinates[0]
  y = coordinates[1]
  w = coordinates[2]
  h = coordinates[3]
  crop_params = "#{w}x#{h}+#{x}+#{y}"

  image = MiniMagick::Image.read(response)
  image.crop crop_params
  image.write "../public/menus/#{place[:name]}.png"
end
