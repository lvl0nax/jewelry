class Product < ActiveRecord::Base
  belongs_to :category

  mount_uploader :photo, PhotoUploader

  scope :with_image, -> { where('photo IS NOT NULL') }

  def name
    category.title + ' ' + self.brand
  end

  def desc
    Info.find_by(product_article: self.article).try(:content)
  end

  def image_exist?
    msk = File.join('**', 'medium', "#{self.article}.*")
    nameF = Dir.glob(msk)
    File.basename(nameF.first) if nameF.present?
  end

  def discount
    info = Info.find_by(product_article: self.article)
    if info.present?
      t = info.discount
      self.price * (100 - t) / 100
    end
  end

  def info
    Info.where(product_article: self.article).first
  end

  def as_json
    {
      id: id,
      article: article,
      price: price,
      category: self.category.title
    }
  end
end
