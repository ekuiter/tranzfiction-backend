class Admin::UsersController < AdminController  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_path(@user), notice: 'Benutzer erstellt.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    p = user_params
    if @user.admin? && !(p[:admin] == "1") && User.admin_count == 1
      flash[:alert] = "Der letzte Admin kann nicht gelöscht werden."
      p[:admin] = true
    end
    respond_to do |format|
      if @user.update_attributes(p)
        flash[:notice] = 'Benutzer gespeichert.' unless flash[:alert]
        format.html { redirect_to admin_user_path(@user) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    flash[:alert] = "Der letzte Admin kann nicht gelöscht werden." unless @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      p = params[:user].permit(:email, :password, :password_confirmation, :admin)
      p = params[:user].permit(:email, :admin) if p[:password].empty? && p[:password_confirmation].empty?
      p
    end
end
