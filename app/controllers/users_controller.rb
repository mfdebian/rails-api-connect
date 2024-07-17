class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index
    users_from_api = UsersService.call

    users_from_api.each do |api_user|
      user = User.find_or_initialize_by(id: api_user['id'])
      user.update(
        name: api_user['name'],
        username: api_user['username'],
        email: api_user['email'],
        phone: api_user['phone'],
        website: api_user['website']
      )
    end

    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    user_data = UsersService.create(user_params)

    @user = User.new(
      name: user_data['name'],
      username: user_data['username'],
      email: user_data['email'],
      phone: user_data['phone'],
      website: user_data['website']
    )

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    updated_user_data = UsersService.update(@user, user_params)
  
    respond_to do |format|
      if @user.update(
          name: updated_user_data['name'],
          username: updated_user_data['username'],
          email: updated_user_data['email'],
          phone: updated_user_data['phone'],
          website: updated_user_data['website']
        )
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    response = UsersService.destroy(@user.id)
  
    if response[:status] == 200
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: response[:message] }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to users_url, alert: response[:message] }
        format.json { render json: { error: response[:message] }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :phone, :website)
  end
end
