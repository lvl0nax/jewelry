class Banner < ActiveRecord::Base
  attr_accessible :alt_text, :image, :lnk, :num
  mount_uploader :image, ImageUploader
end
