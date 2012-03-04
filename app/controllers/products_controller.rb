class ProductsController < InheritedResources::Base
  before_filter :admin_require, :except => [ :show ]
  belongs_to :category

  

end
