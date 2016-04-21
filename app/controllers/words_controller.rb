class WordsController < ApplicationController
  def new
    set_user
    @word = @user.words.new
    @word.word = word_params[:new_word]
  end

  def create
    set_user
    if ValidateHundredWordLength.new(definition).call || true
      word = @user.words.build(word_params[:word])
      if word.save
        redirect_to user_word_url(@user, word)
      end
    end
  end

  def show
    set_user
    set_word
  end

  private

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
end
