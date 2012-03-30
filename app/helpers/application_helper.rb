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
      @allCat = Category.all
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
    return @title ? @title + " | Bujua" : "Bujua"
  end

  

end
