class UsersController < ApplicationController


  def show
    @user = User.find(params[:id])
  end

  def test
    if !!current_user
      @user = current_user #User.find(params[:id])
    else
      redirect_to root_path
    end
  end
end