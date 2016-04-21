class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    set_defined_word_hash
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if ValidateHundredWordLength.new(description).call && @user.save
      redirect_to @user, notice: "User was successfully created."
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :description)
  end

  def description
    user_params[:description]
  end

  def defined_word_models
    @user.words.where(word: @user.description.split)
  end

  def set_defined_word_hash
    @defined_word_hash = defined_word_models.inject({}) do |hash, word_model|
      hash[word_model.word] = word_model
      hash
    end
    @defined_word_hash.default = nil
  end
end
