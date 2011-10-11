class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resize_to_limit => [640, 640]
  process :convert => :png
  
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :convert => :png 
    process :resize_and_pad => [40, 40, :white]
  end
  
  version :small do
    process :convert => :png 
    process :resize_and_pad => [100, 100, :white]
  end
  
  version :medium do
    process :convert => :png 
    process :resize_and_pad => [460, 460, :white]
  end
  
  version :large do
    process :convert => :png 
    process :resize_and_pad => [640, 640, :white]
  end
  
  version :huge do
    process :convert => :png 
    process :resize_to_limit => [960, 960]
  end
      

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def filename
    if not super.nil?
      super.chomp(File.extname(super)) + '.png'
    end
  end

end