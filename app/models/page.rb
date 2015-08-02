class Page < ActiveRecord::Base
  def isMain?
    Page.minimum(:id) == self.id
  end
end
