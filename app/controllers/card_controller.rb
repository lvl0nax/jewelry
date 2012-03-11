class CardController < ApplicationController
  before_filter :admin_require, :except => [ :list, :index, :add_to_card ]

  def index
    if !cookies[:card].nil?
      @card = JSON.parse(cookies[:card])
    end

    if @card.blank?
      redirect_to root_url
    end

    @hide_banner = true
    @hide_search = true
    @hide_card = true
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

    if !current_user
      redirect_to root_url
    end
    if current_user.isAdmin?
      if !!u
        @cards = Card.where(:user_id => u.id)
      else
        @cards = Card.all
      end
    else
      @cards = Card.where(:user_id => current_user.id)
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

end
