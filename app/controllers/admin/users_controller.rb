class Admin::UsersController < AdminController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.paginate page: params[:page], per_page: 20
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = "User create!"
      redirect_to admin_user_path @user
    else
      flash[:danger] = "User create error!"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update user_params
      flash[:success] = "User updated!"
      redirect_to admin_user_path @user
    else
      flash[:danger] = "User update error!"
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
  end

  def user_params
    params.require(:user)
      .permit(:name, :email, :password)
      .merge(password_confirmation: params[:password])
  end
end
