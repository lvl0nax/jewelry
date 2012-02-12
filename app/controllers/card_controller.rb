class CardController < ApplicationController

  def index
    if !cookies[:card].nil?
      @card = JSON.parse(cookies[:card])
    end
    @hide_banner = true
    @hide_search = true
    @hide_card = true
  end

end
