require 'carrierwave/mongoid'

class Image
  include Mongoid::Document
  
  field :caption, :type => String
  
  mount_uploader :file, ImageUploader
  
  embedded_in :post
  
  validates_presence_of :file

end