class Admin::UsersController < AdminController  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to admin_user_path(@user), notice: 'Benutzer erstellt.'
    else
      render action: 'new'
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = 'Benutzer gespeichert.' unless flash[:alert]
      redirect_to admin_user_path(@user)
    else
      render action: 'edit'
    end
  end

  def destroy
    flash[:alert] = "Der letzte Admin kann nicht gelöscht werden." unless @user.destroy
    redirect_to admin_users_path
  end

  private
  
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    p = params[:user].permit(:email, :password, :password_confirmation, :admin)
    p = params[:user].permit(:email, :admin) if p[:password].empty? && p[:password_confirmation].empty?
    p
  end
end
