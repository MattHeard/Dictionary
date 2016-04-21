module ApplicationHelper
  def cleanup(word)
    simplify(word)
  end

  def simplify(word)
    SimplifiedWord.new(word).call
  end

  def colour_decile(word, frequencies)
    decile = deciles(frequencies)[simplify(word)]
    "decile#{decile}"
  end

  def deciles(frequencies)
    max_frequency = frequencies.values.max
    deciles = frequencies.keys.inject({}) do |deciles, word|
      deciles[word] = (frequencies[word] * 10.0 / max_frequency).ceil
      deciles
    end
    deciles.default = 1
    deciles
  end
end
