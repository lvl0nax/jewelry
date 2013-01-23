# -*- encoding : utf-8 -*-
# coding: utf-8
module ApplicationHelper

  def allpages
     if !!session[:pages]
       @allPag = session[:pages]
     else
       #@allPag = Page.all#.select()
       @allPag = Page.find_by_sql("SELECT id, title FROM pages")
       session[:pages] = @allPag
     end
  end

  def allcategories
    if !!session[:categories]
      @allCat = session[:categories]
    else
      @allCat = Category.select("id, title")
      session[:categories] = @allCat
    end
  end

  def fiveproduct
    cat = allcategories
    @allPr = Array.new
    for i in 0..4
      ##TODO: проверка на пустый категории
      tempCat = cat[rand(cat.size)] # Нашли случайную категорию
      prodAll = tempCat.Product.all # нашли все товары в нашей категории
      @allPr << [prodAll[rand(prodAll.size)]] # нашли случайный товар из категории и добавили его в массив

    end
    @allPr
  end

  def title
    return @title ? @title + " | Bujua" : "Bujua - чешская бижутерия"
  end

  def allbrands
    if !!session[:brands]
      return session[:brands]
    else
      brands = Product.select(:brand)
      unless brands.blank?
        brands.collect! {|b| b.brand}
        brands.uniq!
        session[:brands] = brands 
      end
    end
  end

end
