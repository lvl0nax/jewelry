class ProductsController < InheritedResources::Base
  belongs_to :category
end
