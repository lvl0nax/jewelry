# -*- encoding : utf-8 -*-
class CardController < InheritedResources::Base
  before_filter :admin_require, except: [:list, :index, :add_to_card, :add_to_cart, :remove_from_cart,
                                         :show_card, :new, :create]

  def index
    @card = JSON.parse(cookies[:card]) if cookies[:card].present?

    redirect_to root_url if @card.blank?

    @hide_banner = @hide_card = true
  end

  def add_to_cart
    session[:cart_items] ||= []
    session[:cart_items] << (params[:product].to_i if Product.exists?(id: params[:product].to_i))
    @cart_items = Product.where(id: session[:cart_items].map(&:to_i))
    #@price = @cart_items.inject(0) {|sum, i| sum + i.price}
    respond_to do |format|
      format.js {
        render partial: 'card/cart_item', collection: @cart_items
      }
    end
  end
  def remove_from_cart
    id = (params[:product].to_i if Product.exists?(id: params[:product].to_i))
    session[:cart_items].delete_at(session[:cart_items].index(id))
    respond_to do |format|
      format.js {
        if session[:cart_items].blank?
          render text: 'Ваша корзина пуста'
        else
          @cart_items = Product.where(id: session[:cart_items].map(&:to_i))
          render partial: 'card/cart_item', collection: @cart_items
        end
      }
    end
  end

  def add_to_card
    (@card = Card.new).user_id = current_user.try(:id)

    if cookies[:card].present?
      @card.cardjson = cookies[:card]
      cookies[:card] = ''
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
        format.json { render json: {res: '1' } }
      end
    end

  end

  def list
    user = User.find(params[:format]) if params[:format]

    if current_user
      @cards =
        if current_user.isAdmin?
          if user
            Card.where(user_id: user.id)
          else
            Card.all
          end
        else
          Card.where(user_id: current_user.id)
        end
    else
      redirect_to root_url
    end

    @hide_banner = @hide_search = true
  end

  def change_status

    unless current_user
      render json: {res: '0'} and return false
    end

    @card = Card.find_by(id: params[:id])
    @card.status = params[:st]

    render json: {res: '1'} if @card.save

  end

  def show_card
    @card = Card.find(params[:id])
    render layout: false
  end

  def new
    redirect_to :back if session[:cart_items].blank?
    @card = current_user ? current_user.cards.build : Card.new
  end

  def create
    @card = current_user ? current_user.cards.build(params[:card]) : Card.new(params[:card])
    products = Product.select([:id, :article, :price, :category_id]).find(session[:cart_items])
    @card.cardjson = products.as_json.to_s
    sum = products.sum(&:price)
    @card.cost = sum

    if @card.save
      session[:cart_items].clear
      CardMailer.new_order_mail(@card).deliver
      redirect_to root_path
    else
      flash[:notice] = 'Пожалуйста, убедитесь что все необходимые поля заполнены! И повторите попытку снова.'
      render action: :new
    end
  end

  def destroy

  end

end
