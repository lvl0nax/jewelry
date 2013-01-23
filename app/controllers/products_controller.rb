class ProductsController < InheritedResources::Base
  before_filter :admin_require, :except => [ :show ]
  belongs_to :category
  def show
    if !!resource.mtitle
      @title = resource.mtitle
    else  
      @title = "#{resource.category.title} " + "#{resource.brand}"
    end
  end

  def search
    respond_to :js, :json => { :res => "123" }
    render :json => { :res => "123" }
  end

end
