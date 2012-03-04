class Page < ActiveRecord::Base
  def isMain?
    Page.first === self ? true : false
  end
end
