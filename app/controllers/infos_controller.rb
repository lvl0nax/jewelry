class InfosController < InheritedResources::Base
  before_filter :admin_require, :except => [ :show ]
  def new
    @info = Info.new
    @product = Product.find(params[:product_id])
    @info.product_article = @product.article
  end

  def create
    @info = Info.new(params[:info])
    create!{
      category_product_path(@info.find_category, @info.find_product)
    }
    #redirect_to Product.find_by_article(@description.product_article)
 end

  def update
    update! {  
      category_product_url(@info.find_category, @info.find_product) 
    }
  end

end
