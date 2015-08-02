class Info < ActiveRecord::Base

  def find_product
    Product.find_by(article: self.product_article)
  end

  def find_category
    Product.find_by(article: self.product_article).category
  end
end
