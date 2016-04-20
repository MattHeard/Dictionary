class ValidateHundredWordLength
  REQUIRED_WORD_COUNT = 100

  def initialize(string)
    @string = string
  end

  def call
    string.split.size == required_word_count
  end

  private

  attr_reader :string

  def required_word_count
    REQUIRED_WORD_COUNT
  end
end
