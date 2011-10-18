class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, :type => String
  field :slug, :type => String
  field :intro, :type => String
  field :body, :type => String
  field :reads, :type => Integer, :default => 0
  
  belongs_to :user
  has_and_belongs_to_many :tags
  
  embeds_many :images
  embeds_many :comments
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => proc { |attributes| attributes['file'].blank? }
  
  before_save :create_slug, :on => :create
  after_save :save_images
  
  validates :title, :intro, :presence => true
  
  def save_images
    images.each do |image|
      if image.new_record? and image.file.present?
        image.save!
      end
    end
  end
  
  def validate_images
    images.each do |image|
      image.send(:_run_validation_callbacks)
    end
  end
  
  def self.find_by_slug(slug, year=nil, month=nil)
    post = nil
    unless year.nil? or month.nil?
      t = Time.mktime(year, month, 1, 0, 0, 0)
      tlow, thigh = t, t.next_month
      post = first(:conditions => {:slug => slug, :created_at.gt => tlow, :created_at.lt => thigh})
    end
    if post.nil? # fallback to slug instead..
      post = first(:conditions => {:slug => slug})
    end
    post
  end
  
  def read_up
    collection.update({'_id' => self._id}, {'$inc' => {'reads' => 1}})
  end
  
  # Create a slug from the title.
  # From Sluggable Finder: http://github.com/ismasan/sluggable-finder/
  def convert_to_slug(str)
    if defined?(ActiveSupport::Inflector.parameterize)
      ActiveSupport::Inflector.parameterize(str).to_s
    else
      ActiveSupport::Multibyte::Handlers::UTF8Handler.
       normalize(str,:d).split(//u).reject { |e| e.length > 1 }.join.strip.gsub(/[^a-z0-9]+/i, '-').downcase.gsub(/-+$/, '')
    end
  end

  # Note: this slug creation code is vulnerable to race conditions.
  # Refactoring forthcoming.
  def create_slug
    return if self.title.blank?
    tail, int = "", 1
    initial   = convert_to_slug(self.title)
    while Post.first(:conditions => {:slug => initial + tail, :_id.ne => self._id}) do 
      int  += 1
      tail = "-#{int}"
    end
    self.slug = initial + tail
  end
  
  # forward validation to embedded documents
  def valid?(*)
     _run_validation_callbacks { super }
     validate_images
  end
  
end
