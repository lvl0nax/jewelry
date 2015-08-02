class PagesController < InheritedResources::Base #ApplicationController
  before_filter :admin_require, :except => [ :show, :index ]
  before_filter :rand_products, :only => [:show]

  # include TinymceFm::Filemanager

  # image_accept_mime_types ['image/jpeg', 'image/gif', 'image/png']

  # # limit image file size to 2MB
  # image_file_size_limit 2.megabytes
  # #thumbs created into '_small_' subdir
  # thumbs_subdir 'small'

  def show
    @title = resource.mtitle || resource.title
  end

  def index
    @banners = Banner.order(:num).limit(3)
    @products = Product.with_image.where(for_main_page: true).first(3)
    @products = Product.with_image.first(3) if @products.count < 3
    @title = Dopinfo.where(tag: 'main').first.try(:title)
  end

  def import_excel
    #for CATEGORY model
    catAr = Category.all
    toCat = []
    if catAr.blank?
      last = 0
    else
      last = catAr.last.id
    end

    objs = []
    sql = ActiveRecord::Base.connection()
    sql.execute("TRUNCATE products ")
    tbl = Excel.new("qwerty.xls") #should be original name in root directory for the site
    tbl.default_sheet = tbl.sheets.first
    2.upto(tbl.last_row) do |line|
     #TODO: customize to our product
       article = tbl.cell(line, 'A')
       price = tbl.cell(line, 'B')

       type = tbl.cell(line, 'C')

       brand = tbl.cell(line, 'D')

       # to find category ID.
       ca = catAr.select{|c| c.title == type}
       if ca.blank?
        last = last + 1
        cat_id = last
        title = ca.title
        toCat.push("('#{title}')")
       else
        cat_id = ca.first.id
       end
      # create objs array to insert to table products
       objs.push("('#{article}', '#{price}', '#{brand}','#{cat_id}')")
       logger.debug title
    end

    #fill DB
    sql.execute("INSERT INTO `products` (`article`, `price`, `brand`, `category_id`) VALUES " + objs.join(','))
    unless toCat.blank?
      sql.execute("INSERT INTO `categories` (`title`) VSLUES " + toCat.join(','))
    end
  end
end
