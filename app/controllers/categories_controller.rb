class CategoriesController <  InheritedResources::Base #ApplicationController #
  before_filter :admin_require, :except => [ :show ]#:only => [:new, :create, :edit, :update, :destroy]

#  # GET /categories
#  # GET /categories.json
 # def index
 #   @categories = Category.all

 #   respond_to do |format|
 #     format.html # index.html.erb
 #     format.json { render :json => @categories }
 #   end
 # end

#  # GET /categories/1
#  # GET /categories/1.json
#  def show
#    @category = Category.find(params[:id])

#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render :json => @category }
#    end
#  end

#  # GET /categories/new
#  # GET /categories/new.json
#  def new
#    @category = Category.new

#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render :json => @category }
#    end
#  end

#  # GET /categories/1/edit
#  def edit
#    @category = Category.find(params[:id])
#  end

def show
  @title = resource.title
  tmp = all_photo_name
  @products = Product.where(:article => tmp, :category_id => @category.id)
  if !!@products
    @products = @products.page(params[:page]).per_page(20)
  end
end

def create
  create!{ root_url }
end

#  # PUT /categories/1
#  # PUT /categories/1.json
#  def update
#    @category = Category.find(params[:id])

#    respond_to do |format|
#      if @category.update_attributes(params[:category])
#        format.html { redirect_to @category, :notice => 'Category was successfully updated.' }
#        format.json { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.json { render :json => @category.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

#  # DELETE /categories/1
#  # DELETE /categories/1.json
#  def destroy
#    @category = Category.find(params[:id])
#    @category.destroy

#    respond_to do |format|
#      format.html { redirect_to categories_url }
#      format.json { head :ok }
#    end
#  end

end
