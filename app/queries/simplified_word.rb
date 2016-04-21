class SimplifiedWord
  WHITELIST = %w{
    I is was his Wikipedia US us politics ethics overseas as 80s Timberlake's
    has
  }

  def initialize(word)
    @word = word
  end

  def call
    word.gsub!(matcher, "")
    if whitelist.include?(word)
      word
    else
      word.downcase.singularize
    end
  end

  private

  attr_reader :word

  def matcher
    /^[^[:word:]]*|[^[:word:]]*$/
  end

  def whitelist
    WHITELIST
  end
end
