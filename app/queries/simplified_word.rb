class SimplifiedWord
  def initialize(word)
    @word = word
  end

  def call
    word.downcase.gsub(matcher, "").singularize
  end

  private

  attr_reader :word

  def matcher
    /^[^[:word:]]*|[^[:word:]]*$/
  end
end
