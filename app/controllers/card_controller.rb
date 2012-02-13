class CardController < ApplicationController

  def index
    if !cookies[:card].nil?
      @card = JSON.parse(cookies[:card])
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

    if @card.save
      respond_to do |format|
        format.html {
          redirect_to '/card/list'
        }
        format.json { render :json => {
            :res => "1",
        } }
      end
    end

  end

  def list

    @card = Card.all

    @hide_banner = true
    @hide_search = true
    @hide_card = true


  end

end
