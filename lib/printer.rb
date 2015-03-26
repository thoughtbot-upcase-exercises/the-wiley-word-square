require 'benchmark'
require_relative './word_square'

class Printer
  attr_reader :words

  def initialize(words)
    @words = words
  end

  def print
    words.each do |word|
      puts formatted_word(word)
    end
  end

  def formatted_word(word)
    word.split("").join(" ").upcase
  end
end

puts Benchmark.measure {
  words = WordSquare.new(5).solve
  Printer.new(words).print
}
