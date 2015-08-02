class Search < ActiveRecord::Base
  def products
    @products = find_products
  end
  
  #private
    def find_products
      flag = 0
      str = 'SELECT * FROM products WHERE ('
      s = self.category_id
      unless s.blank?
        #idArr = s.split(",")
        str +=('products.category_id IN (' + s + '))')
        #logger.debug "++++++++++++++++++++++++++++++++++++++++"
        #logger.debug products.first.article
        flag = 1
      end
      
      s = self.min_price.to_s
      unless s.blank?
        if flag > 0
          str += ' AND ('
        end
        str += ('products.price >= ' + s +')')
        flag = 1
      end

      s = self.mas_price.to_s
      unless s.blank?
        if flag > 0
          str += ' AND ('
        end
        str +=('products.price <= ' + s +')')
        flag = 1
      end

      #TODO: add brand filter!!!
      logger.debug '++++++++++++++++++++++++++++++++++++++++'
      logger.debug str


      #products = Product.where(:category_id => idArr)
      #products = products.where(:category_id => category_id) if category_id.present?
      #products = products.where("price >= ?", min_price) if min_price.present?
      #products = products.where("price <= ?". msas_price) if mas_price.present?
      if flag == 0
        products = Product.all
      else
        products = Product.find_by_sql(str)   #check it!!!!!
      end
      logger.debug 'ccccccooooooouuunnnnnnttt-----------------'
      logger.debug products.count

      products
    end
end
