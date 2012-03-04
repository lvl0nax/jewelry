class Category < ActiveRecord::Base
  has_many :products

  def name
    self.title.mb_chars.upcase 
  end
  
end
