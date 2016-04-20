class WordsController < ApplicationController
  def new
    set_user
    @word = @user.words.new
    @word.word = word_params[:word]
  end

  private

  def set_user
    @user = User.find(word_params[:user_id])
  end

  def word_params
    params.permit(:user_id, :word)
  end
end
