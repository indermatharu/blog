class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  # GET /users or /users.json
  def index

    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @articles = @user.articles
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    # respond_to do |format|
    #   if @user.save
    #     format.html { redirect_to user_url(@user), notice: "User was successfully created." }
    #     format.json { render :show, status: :created, location: @user }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the Blog, #{@user.username} you have successfully signed up."
      redirect_to articles_path
    else
      render "new"
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if @user.update(user_params)
      flash[:notice] = "Your account successfully updated."
      redirect_to @user
    else
      render "edit"
    end
    # respond_to do |format|
    #   if @user.update(user_params)
    #     format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
    #     format.json { render :show, status: :ok, location: @user }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
    #
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    session[:user_id] = nil
    flash[:notice] = "Account and all associated articles are deleted."
    redirect_to root_path
    # respond_to do |format|
    #   format.html { redirect_to users_url, notice: "User was successfully destroyed." }
    #   format.json { head :no_content }
    # end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    if current_user != @user
      flash[:alert] = "You can only edit or delete your own article"
      redirect_to current_user
    end
  end

end
