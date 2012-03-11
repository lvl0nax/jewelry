class PagesController < InheritedResources::Base #ApplicationController
  before_filter :admin_require, :except => [ :show, :index ]
  before_filter :rand_products

  include TinymceFm::Filemanager

  image_accept_mime_types ['image/jpeg', 'image/gif', 'image/png']

  # limit image file size to 2MB
  image_file_size_limit 2.megabytes
  #thumbs created into '_small_' subdir
  thumbs_subdir 'small'

  def show
    @title = resource.title
  end

  def index
    if Page.all.blank?
      redirect_to new_page_path
    else
      @page = Page.first 
      render "show"
    end
  end
#  # GET /pages
#  # GET /pages.json
#  def index
#    @pages = Page.all

#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render :json => @pages }
#    end
#  end

#  # GET /pages/1
#  # GET /pages/1.json
#  def show
#    @page = Page.find(params[:id])

#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render :json => @page }
#    end
#  end

#  # GET /pages/new
#  # GET /pages/new.json
#  def new
#    @page = Page.new

#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render :json => @page }
#    end
#  end

#  # GET /pages/1/edit
#  def edit
#    @page = Page.find(params[:id])
#  end

#  # POST /pages
#  # POST /pages.json
#  def create
#    @page = Page.new(params[:page])

#    respond_to do |format|
#      if @page.save
#        format.html { redirect_to @page, :notice => 'Page was successfully created.' }
#        format.json { render :json => @page, :status => :created, :location => @page }
#      else
#        format.html { render :action => "new" }
#        format.json { render :json => @page.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

#  # PUT /pages/1
#  # PUT /pages/1.json
#  def update
#    @page = Page.find(params[:id])

#    respond_to do |format|
#      if @page.update_attributes(params[:page])
#        format.html { redirect_to @page, :notice => 'Page was successfully updated.' }
#        format.json { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.json { render :json => @page.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

#  # DELETE /pages/1
#  # DELETE /pages/1.json
#  def destroy
#    @page = Page.find(params[:id])
#    @page.destroy

#    respond_to do |format|
#      format.html { redirect_to pages_url }
#      format.json { head :ok }
#    end
#  end

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
