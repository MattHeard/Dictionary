class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    set_defined_word_hash
    set_frequencies
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

  def set_frequencies
    descriptions = User.pluck(:description)
    words = descriptions.join(" ").split.map { |word| SimplifiedWord.new(word).call }
    pp words
    @frequencies = words.inject({}) do |frequencies, word|
      count = words.count { |w| w == word }
      frequencies[word] = count if count > 1
      frequencies
    end
    @frequencies.default = 0
  end
end
