class CardController < ApplicationController

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
    @card.status = 1

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

    if !current_user
      redirect_to root_url
    end

    @cards = Card.all

    @hide_banner = true
    @hide_search = true

  end

end
