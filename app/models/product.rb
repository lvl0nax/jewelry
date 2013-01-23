require 'RMagick'

class Product < ActiveRecord::Base
  belongs_to :category


  def title
    category.title + " " + self.brand
  end

  def desc
    if Info.find_by_product_article(self.article).blank?

      return nil
    else
      Info.find_by_product_article(self.article).content
    end
  end

  def image_exist?
    msk = File.join("**","medium", "#{self.article}.*")
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

  def self.convert_image
        test = File.new("test.txt", "w")
        test.syswrite("Thread started\n")
        mask = File.join("**", "bujua", "*.jpg" )
        ims = Dir.glob(mask)
        mask = File.join("**", "bujua", "*.JPG" )

        #imNameL = Dir.glob(mask)
        #ims = ims + imNameL #list of all images
        #ims = ims + Dir.glob(mask)
        ims |= Dir.glob(mask)

        test.syswrite("Search ended\n")
        ims.collect!{|im| File.basename(im)}

        test.syswrite("start creating pictures\n")
        ims.each{|p|
          #test.syswrite("#{ims.join(',')}") # - all name of images
          clown = Magick::Image.read("#{Rails.root}/app/assets/images/bujua/#{p}").first
          test.syswrite("read image \n")
          test.syswrite("#{Time.now} \n") # - time action
          tmp = clown.resize_to_fit(130, 130)
          test.syswrite("resize image \n")
          tmp.write("#{Rails.root}/app/assets/images/thumb/#{p.split(".").first}.jpg")
          test.syswrite("sace to thumb \n")
          tmp = clown.resize_to_fit(600, 800)
          test.syswrite("resize to medium \n")
          tmp.write("#{Rails.root}/app/assets/images/medium/#{p.split(".").first}.jpg")
          test.syswrite("save to medium \n")
        }
  end

  def self.import_from_excel
                  toCat = []
                  objs = []
                  
                  catAr = Category.all
                  catAr.each {|c| toCat.push("('#{c.title}')")}
                  sql = ActiveRecord::Base.connection()
                  sql.execute("TRUNCATE products ")
                  tbl = Excel.new("qwerty.xls") #should be original name in root directory for the site
                  tbl.default_sheet = tbl.sheets.first
                  
                  #TODO: customize to our product
                  
                  j = 0
                  2.upto(tbl.last_row) do |line|
                    j=j+1

                    article = tbl.cell(line, 'A')
                    next if article.blank?
                    price = tbl.cell(line, 'F')
                    type = tbl.cell(line, 'B')
                    brand = tbl.cell(line, 'D')
                    descr = tbl.cell(line, 'C')
                    #     check that category is exists in DB
                    i = toCat.index("('#{type}')")
                    if i.nil?  
                      cat_id = toCat.length     
                      toCat.push("('#{type}')")
                    else  
                      cat_id = i + 1
                    end
                    objs.push("('#{article}', '#{price}', '#{brand}','#{cat_id}')")
                  end

                  #fill DB
                  sql.execute("TRUNCATE categories ")
                  sql.execute("INSERT INTO `categories` (`title`) VALUES " + toCat.join(','))
                  sql.execute("INSERT INTO `products` (`article`, `price`, `brand`, `category_id`) VALUES " + objs.join(','))
  end
end
