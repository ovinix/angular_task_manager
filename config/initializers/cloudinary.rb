if Rails.env.production?
  Cloudinary.config do |config|
    uri = URI.parse(ENV['CLOUDINARY_URL'])
    config.api_key = uri.user
    config.api_secret = uri.password
    config.cloud_name = uri.host
  end
end