class ApplicationController < ActionController::Base
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
      if i.nil?    check that we do not add category yet
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
end
