class Admin::CategoriesController < AdminController
  before_action :find_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all.paginate(:page => params[:page], :per_page => 10)
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category created !"
      redirect_to admin_categories_path
    else
      flash[:alert] = "Category creating error !"
      render :index
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      flash[:alert] = "Category updated !"
      redirect_to admin_categories_path
    else
      flash[:alert] = "Category updating error !"
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
  end
end
