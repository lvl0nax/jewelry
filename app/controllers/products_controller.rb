# -*- encoding : utf-8 -*-
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
    args = {img: true}
    args.merge!({category_id: params[:category]}) unless params[:category].blank?
    args.merge!({brand: params[:brand]}) unless params[:brand].blank?
    # category = params[:category] || nil
    # price = params[:price] || nil
    # brand = ''
    # args.merge!({category_id: params[:category]}) if params[:category]
    # prc = 0..1000
    case params[:price]
      when '1' then args.merge!({price: 0..1000}) #prc = 0..1000
      when '2' then args.merge!({price: 1000..3000}) #prc = 1000..3000
      when '3' then args.merge!({price: 3000..1000000}) #prc = 3000..800000
    end
    logger.debug '================================'
    logger.debug args
    logger.debug '================================'
    @products = Product.where(args).first(20)
    # respond_to :js, :json => { :res => "123" }
    # render :json => { :res => "123" }
    if @products.blank?
      render text: 'По Вашему запросу ни чего не найдено! Измените параметры и повторите попытку позже.'
    else
      render @products
    end
  end

  def search_results

  end

end
