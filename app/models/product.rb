require 'RMagick'

class Product < ActiveRecord::Base
  belongs_to :category

  mount_uploader :photo, PhotoUploader

  scope :with_image, -> { where('photo IS NOT NULL') }

  def name
    category.title + ' ' + self.brand
  end

  def desc
    if Info.find_by_product_article(self.article).blank?

      return nil
    else
      Info.find_by_product_article(self.article).content
    end
  end

  def image_exist?
    msk = File.join('**', 'medium', "#{self.article}.*")
    nameF = Dir.glob(msk)
    File.basename(nameF.first) unless nameF.blank?
    #nameF.empty? ? true : false
  end

  def discount

    #TODO: Price with discount should be printed on site

    if Info.find_by_product_article(self.article).blank?
      return nil
    else
      t = Info.find_by_product_article(self.article).discount
      total_price = self.price * (100 - t) / 100
    end
  end

  def info
    #Description.find_by_product_article(self.article)
    Info.where(:product_article => self.article).first
    #Description.first("product_article = '#{self.article}'")
  end

end
