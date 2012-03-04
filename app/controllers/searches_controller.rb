class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    @search = Search.create!(params[:search])
    logger.debug "==============category id ==============="
    logger.debug @search.category_id
    logger.debug "===============params ==================="
    logger.debug params[:search][:category_id].join(",")
    @search.category_id = params[:search][:category_id].join(",")
    @search.save
    redirect_to @search
  end

  def show
    @search = Search.find(params[:id])
  end
end
