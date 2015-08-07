# -*- encoding : utf-8 -*-
class ProductsController < InheritedResources::Base
  before_filter :admin_require, except: [:show, :search, :upload_photos]
  belongs_to :category
  def show
    @title = resource.mtitle || "#{resource.category.title} " + "#{resource.brand}"
    prs = Product.with_image.where(category_id: resource.category_id).sample(10)
    @prs1 = prs[0]
    @prs2 = prs[1..4]
    @prs3 = prs[5..8]
    @prs4 = prs[9]
  end

  def search
    args = {}
    args[:category_id] = params[:category] if params[:category].present?
    args[:brand] = params[:brand] if params[:brand].present?
    case params[:price]
      when '1' then args[:price] = 0..1000 #prc = 0..1000
      when '2' then args[:price] = 1000..3000 #prc = 1000..3000
      when '3' then args[:price] = 3000..1000000 #prc = 3000..800000
    end
    @products = Product.with_image.where(args).first(20)
    if @products.blank?
      render text: 'По Вашему запросу ни чего не найдено! Измените параметры и повторите попытку позже.'
    else
      render @products
    end
  end

  def search_results; end

  def pictures_process
    PictureWorker.perform_async
    render nothing: true
  end

  def products_process
    ProductsWorker.perform_async
    render nothing: true
  end

end
