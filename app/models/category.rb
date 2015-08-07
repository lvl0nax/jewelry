class Category < ActiveRecord::Base
  has_many :products

  def name
    self.title.mb_chars.upcase 
  end

  def self.append_new(titles)
    self.connection.execute(
      'INSERT INTO categories (title) VALUES ' + titles.join(',')
    )
  end
  
end
