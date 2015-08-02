class SearchesController < ApplicationController
  respond_to :html, :js

  def new
    @search = Search.new
  end

  def create
    @search = Search.create!(params[:search])
    @search.category_id = params[:search][:category_id].join(',')
    @search.save!
    respond_with @search
  end

  def update
    respond_with @search
  end

  def show
    respond_with(@search = Search.find(params[:id]))
  end


  def test
    @test = 'its successful example!! Nice work!s'
    
    # correct code  
      flag = 0
      tmp = all_photo_name
      str = "SELECT * FROM products WHERE  ("
      str += ("products.article IN (" + tmp + "))")
      s = params[:cat]
      unless s.blank?
        str += " AND ("
        str +=("products.category_id IN (" + s + "))")
        flag = 1
      end
      
      s = params[:min]
      unless s.blank?
        #if flag > 0
          str += " AND ("
        #end
        str += ("products.price >= " + s +")")
        flag = 1
      end

      s = params[:max]
      unless s.blank?
        #if flag > 0
          str += " AND ("
        #end
        str +=("products.price <= " + s +")")
        flag = 1
      end

      #TODO: add brand filter!!!



      #products = Product.where(:category_id => idArr)
      #products = products.where(:category_id => category_id) if category_id.present?
      #products = products.where("price >= ?", min_price) if min_price.present?
      #products = products.where("price <= ?". msas_price) if mas_price.present?
      if flag == 0
        @prods = Product.where(:article => tmp).first(100)
      else
        @prods = Product.find_by_sql(str)   #check it!!!!!
      end


      
    #end correct code
    
    render :layout => false
  end

  def index
    respond_with(@search = Search.last)
  end
end
