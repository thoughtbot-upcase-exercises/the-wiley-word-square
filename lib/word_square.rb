require 'algorithms'

class WordSquare
  WORD_LIST_PATH = 'lib/words.lst'
  attr_reader :size, :successful_words, :failed_words

  def initialize(size = 5)
    @size = size
    @successful_words = []
    @failed_words = []
  end

  def solve
    set_random_starting_word
    until solved?
      add_matching_word
    end
    successful_words
  end

  private

  def solved?
    successful_words.length == size
  end

  def add_matching_word
    if potential_words.empty?
      remove_last_word
    else
      successful_words << potential_words.sample
    end
  end

  def remove_last_word
    failed_words << successful_words.pop
  end

  def potential_words
    words_with_prefix = words.wildcard(last_prefix) || []
    words_with_prefix -= failed_words
  end

  def last_prefix
    next_letters_of_successful_words.join("") + wildcard_padding
  end

  def next_letters_of_successful_words
    length = successful_words.length
    successful_words.map { |word|
      word[length]
    }
  end

  def wildcard_padding
    ("*" * (size - successful_words.length))
  end

  def set_random_starting_word
    random_word = words.wildcard("*" * size).sample
    @successful_words = [random_word]
  end

  def words
    @words ||= words_with_puzzle_length
  end

  def words_with_puzzle_length
    trie = Containers::Trie.new
    words_from_file.each do |word|
      if word.length == size
        trie.push(word.downcase, '')
      end
    end
    trie
  end

  def words_from_file
    File.read(WORD_LIST_PATH).split("\n").map { |word| word }
  end
end
