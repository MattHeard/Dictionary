class WordsController < ApplicationController
  COMMON_WORDS = %w{
    the of and a to in is you that it he was for on are as with his they I at be
    this have from or one had by word but not what all were we when your can
    said there use an each which she do how their if will up other about out
    many then them these so some her would make like him into time has look two
    more write go see number no way could people my than first water been call
    who oil its now find long down day did get come made may part
  }

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
    set_frequencies(@word.word)
  end

  def show_all
    @word = params[:word]
    set_definitions(@word)
    set_frequencies(@word)
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
    @user.words.where(word: @word.definition.split.map { |word| SimplifiedWord.new(word).call })
  end

  def set_defined_word_hash
    @defined_word_hash = defined_word_models.inject({}) do |hash, word_model|
      hash[word_model.word] = word_model
      hash
    end
    @defined_word_hash.default = nil
  end

  def set_frequencies(word)
    definitions = Word.where(word: word).pluck(:definition)
    words = definitions.join(" ").split.map { |word| SimplifiedWord.new(word).call }
    words -= common_words
    words.delete(word)
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

  def set_definitions(word)
    @definitions = Word.where(word: word).map do |word|
      { author: word.user.name, text: word.definition }
    end
    @definitions.shuffle!
  end
end
