module ApplicationHelper
  def allpages
    @allPag = Page.all
  end

  def allcategories
    @allCat = Category.all
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
