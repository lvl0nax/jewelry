class Info < ActiveRecord::Base

def find_product
    @product = Product.find_by_article(self.product_article)
    #@product = Product.find(:article => self.product_article)
  end

  def find_category
    @product = Product.find_by_article(self.product_article)
    @product.category
  end
  
end
