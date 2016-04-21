module ApplicationHelper
  def cleanup(word)
    strip_non_word_characters_matcher = /^[^[:word:]]*|[^[:word:]]*$/
    word.downcase.gsub(strip_non_word_characters_matcher, "").singularize
  end
end
