class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :about, :type => String
  field :user_id, :type => String
  
  embeds_one :image
  accepts_nested_attributes_for :image, :allow_destroy => true, :reject_if => :all_blank
  
  mount_embedded_uploader :image, :file
  
  belongs_to :user
  
  validates :name, :presence => true
  
end