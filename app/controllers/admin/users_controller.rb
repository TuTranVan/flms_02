class Admin::UsersController < ApplicationController
  before_action :load_user, only: %i(edit update)

  def index
    @users = User.alphabet.paginate page: params[:page],
      per_page: Settings.per_page.users
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "controller.user.create.success"
      redirect_to admin_users_path
    else
      flash[:danger] = t "controller.user.create.failed"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controller.user.update.success"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :phone, :address,
      :password, :password_confirmation, :role
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controller.user.load_fail"
    redirect_to admin_users_path
  end
end
