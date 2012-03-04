require 'RMagick'

class ApplicationController < ActionController::Base
  helper_method :all
  helper_method :logged_in?
  protect_from_forgery

  def import_excel

    #for CATEGORY model
    toCat = []
    objs = []
    
    catAr = Category.all
    catAr.each {|c| toCat.push("('#{c.title}')")}
    sql = ActiveRecord::Base.connection()
    sql.execute("TRUNCATE products ")
    tbl = Excel.new("qwerty.xls") #should be original name in root directory for the site
    tbl.default_sheet = tbl.sheets.first
    2.upto(tbl.last_row) do |line|
     #TODO: customize to our product
      article = tbl.cell(line, 'A')
      price = tbl.cell(line, 'B')
      type = tbl.cell(line, 'D')
      brand = tbl.cell(line, 'C')

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
end
