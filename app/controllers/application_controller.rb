require 'RMagick'

class ApplicationController < ActionController::Base
  helper_method :all
  helper_method :logged_in?
  helper_method :rand_products
  helper_method :is_admin?
  protect_from_forgery

  def import_excel
   test_thread = Thread.new do
                  #for CATEGORY model
                  toCat = []
                  objs = []
                  
                  catAr = Category.all
                  catAr.each {|c| toCat.push("('#{c.title}')")}
                  sql = ActiveRecord::Base.connection()
                  sql.execute("TRUNCATE products ")
                  tbl = Excel.new("qwerty.xls") #should be original name in root directory for the site
                  tbl.default_sheet = tbl.sheets.first
                  
                  #TODO: customize to our product
                  #10.upto(tbl.last_row) do |line|
                  #  article = tbl.cell(line, 'A')
                  #  type = tbl.cell(line, 'B')
                  #  price = tbl.cell(line.'D')
                  #  brand = tbl.cell(line,'E')
                  j = 0
                  2.upto(tbl.last_row) do |line|
                    j=j+1
              logger.debug j
                    article = tbl.cell(line, 'A')
                    next if article.blank?
                    price = tbl.cell(line, 'F')
                    type = tbl.cell(line, 'B')
                    brand = tbl.cell(line, 'D')
                    descr = tbl.cell(line, 'C')
              logger.debug "-------- #{article} - #{type} - #{price}"
                    #     check that category there is in DB
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


    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :ok }
    end
  end

  def image_convert
    # clown = Magick::ImageList.new("clown.jpg")
    # clown = clown.quantize(256, Magick::GRAYColorspace)
    # clown.write('monochrome.jpg')


    clown = Magick::Image.read("#{Rails.root}/pictures/original/clown.jpg").first
    #clown.crop_resized!(75, 75, Magick::CenterGravity)
    clown.scale(0.3)
    clown.write("#{Rails.root}/pictures/thumb/clown2.jpg")

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :ok }
    end
  end


  def clear_images
    # all products
    iNameS = Product.find_by_sql("SELECT article FROM products")
    iNameS.collect! {|image| image.article + ".jpg"}
    
    logger.debug "/////inames/////////////////////////////////////////"
    logger.debug iNameS

    # all images
    mask = File.join("**","bujua", "*.jpg")
    iNameF = Dir.glob(mask)
    iNameF.collect! {|name| File.basename(name)}
    
    logger.debug "/////inamef/////////////////////////////////////////"
    logger.debug iNameF


    iName = iNameF - iNameS
    
    logger.debug "/////////////////////////////////////////////iName/"
    logger.debug iName

    iName.each do |i| 
      mask = File.join("**","bujua", i)
      iNameS = Dir.glob(mask)
      temp = File.delete(iNameS.first)
      logger.debug "//////////////////////////////////////////////"
      logger.debug temp
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
    end
  end




  private

  def admin_require
    unless is_admin?
      deny_access 
    end  
#    unless logged_in? 
#      flash[:error] = t('users.must_login') 
#      redirect_to login_url # halts request cycle  
#    end
  end  
  
  def deny_access
    flash[:error] = "you have no accessible right/ access denied." 
    redirect_to pages_path #root_url
  end
  

  def is_admin?
    if current_user
      !!current_user.isAdmin?
    else 
      return false
    end
  end

  def rand_products
    Product.all.shuffle.first(5)
  end
end
