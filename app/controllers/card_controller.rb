# -*- encoding : utf-8 -*-
class CardController < InheritedResources::Base
  before_filter :admin_require, :except => [ :list, :index, :add_to_card, :show_card ]

  def index
    if !cookies[:card].nil?
      @card = JSON.parse(cookies[:card])
    end

    if @card.blank?
      redirect_to root_url
    end

    @hide_banner = true

    @hide_card = true
  end

  def add_to_cart

    session[:cart_items] ||= []
    session[:cart_items] << Product.find(params[:product]).id
    logger.debug 'test'
    logger.debug session[:cart_items]
    @cart_items = session[:cart_items].map{|i| Product.find(i)}
    #@price = @cart_items.inject(0) {|sum, i| sum + i.price}
    respond_to do |format|
      format.js {
        render partial: 'card/cart_item', collection: @cart_items
      }
    end
  end
  def remove_from_cart
    session[:cart_items].delete_at(session[:cart_items].index(Product.find(params[:product]).id))
    logger.debug 'test'
    respond_to do |format|
      format.js {
        if session[:cart_items].blank?
          render text: 'Ваша корзина пуста'
        else
          @cart_items = session[:cart_items].map{|i| Product.find(i)}
          render partial: 'card/cart_item', collection: @cart_items
        end
      }
    end
  end

  def add_to_card

    @card = Card.new

    if current_user
      @card.user_id = current_user.id
    end

    if !cookies[:card].nil?
      @card.cardjson = cookies[:card]
      cookies[:card] = ""
    end

    @card.phone = params[:phone]
    @card.fio = params[:fio]
    @card.status = 0
    @card.email = params[:email]
    @card.city = params[:city]
    @card.address = params[:address]
    @card.has_courier = params[:has_courier]
    @card.comment = params[:comment]

    if @card.save
      respond_to do |format|
        format.html {
          redirect_to '/card/list'
        }
        format.json { render :json => {
            :res => "1"
        } }
      end
    end

  end

  def list
    if !!params[:format]
      u = User.find(params[:format])
    end

    if current_user


      if current_user.isAdmin?
        if !!u
          @cards = Card.where(:user_id => u.id)
        else
          @cards = Card.all
        end
      else
        @cards = Card.where(:user_id => current_user.id)
      end
    else
      redirect_to root_url
    end

    @hide_banner = true
    @hide_search = true

  end

  def change_status

    if (!current_user)
      render :json => { :res => "0" }
      return false
    end

    @card = Card.find_by_id(params[:id])
    @card.status = params[:st]

    if @card.save
        render :json => { :res => "1" }
    end

  end

  def show_card
    @card = Card.find(params[:id])
    render :layout => false
  end

  def new
    if session[:cart_items].blank?
      redirect_to :back
    end
    @card = current_user.cards.build
  end

  def create
    @card = current_user.cards.build params[:card]
    sum = 0
    items = Product.select([:article, :price, :category_id]).find(session[:cart_items])
    @card.cardjson = items.as_json
    items.each do |item|
      sum = sum + item.price
    end
    @card.cost = sum

    if @card.save
      redirect_to root_path
      session[:cart_items].clear
    else
      render action: :new
    end
  end

  def destroy

  end

end
