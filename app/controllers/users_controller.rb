class UsersController < ApplicationController
  COMMON_WORDS = %w{
    the of and a to in is you that it he was for on are as with his they I at be
    this have from or one had by word but not what all were we when your can
    said there use an each which she do how their if will up other about out
    many then them these so some her would make like him into time has look two
    more write go see number no way could people my than first water been call
    who oil its now find long down day did get come made may part
  }

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
    @words = Word.pluck(:word).sort
  end

  def show
    set_defined_word_hash
    set_frequencies
    @words = @user.words.sort_by { |word| word.word }
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
    @user.words.where(word: @user.description.split.map { |word| SimplifiedWord.new(word).call })
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
    words -= common_words
    @frequencies = words.inject({}) do |frequencies, word|
      count = words.count { |w| w == word }
      frequencies[word] = count if count > 1
      frequencies
    end
    @frequencies.default = 0
  end

  def common_words
    COMMON_WORDS
  end
end
