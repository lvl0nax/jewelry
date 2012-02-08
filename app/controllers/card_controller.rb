class CardController < ApplicationController

  def index
    @card = JSON.parse(cookies[:card])
    @hide_banner = true
    @hide_search = true
    @hide_card = true
  end

end
