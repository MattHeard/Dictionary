class WordsController < ApplicationController
  def new
    set_user
    @word = @user.words.new
    @word.word = word_params[:new_word]
  end

  def create
    set_user
    build_word
    if ValidateHundredWordLength.new(definition).call && @word.save
      redirect_to user_word_url(@user, @word)
    else
      render :new
    end
  end

  def show
    set_user
    set_word
    set_defined_word_hash
  end

  private

  def build_word
    @word = @user.words.build(word_params[:word])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_word
    @word = @user.words.find(params[:id])
  end

  def word_params
    params.permit(:new_word, :user_id, word: [ :word, :definition ])
  end

  def definition
    params[:word][:definition]
  end

  def defined_word_models
    @user.words.where(word: @word.definition.split)
  end

  def set_defined_word_hash
    @defined_word_hash = defined_word_models.inject({}) do |hash, word_model|
      hash[word_model.word] = word_model
      hash
    end
    @defined_word_hash.default = nil
  end
end
