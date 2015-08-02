class CategoriesController <  InheritedResources::Base #ApplicationController #
  before_filter :admin_require, except: [:show]  #:only => [:new, :create, :edit, :update, :destroy]


def show
  @title = resource.mtitle || resource.title
  @products = Product.with_image.where(category_id: @category.id).page(params[:page]).per(20)
end

def create
  create!{ root_url }
end

end
