class CategoriesController <  InheritedResources::Base #ApplicationController #
  before_filter :admin_require, :except => [ :show ]#:only => [:new, :create, :edit, :update, :destroy]


def show
  @title = resource.title
  tmp = all_photo_name
  @products = Product.where(:article => tmp, :category_id => @category.id).page(params[:page]).per_page(20)

end

def create
  create!{ root_url }
end

end
