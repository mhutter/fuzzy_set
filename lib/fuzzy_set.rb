require 'fuzzy_set/version'
require 'core_ext/string'

# FuzzySet implements a fuzzy-searchable set of strings.
#
# As a set, it cannot contain duplicate elements.
#
# @example
#     states = open('states.txt').read.split(/\n/)
#     fs = FuzzySet.new
#     fs.add(states)
#
#     fs.exact_match('michigan!') # => "Michigan"
#     fs.exact_match('mischigen') # => nil
#
#     fs.get('mischigen')
#     # => ["Michigan", "Minnesota", "Mississippi", "Missouri", "Wisconsin"]
class FuzzySet
  NGRAM_SIZE = 3

  def initialize
    @items = []
    @denormalize = {}
    @index = {}
  end

  # Normalizes +query+, and looks up an entry by its normalized value.
  #
  # @param query [String] search query
  # @return [String] matched (denormalized) value or `nil`
  def exact_match(query)
    @denormalize[normalize(query)]
  end

  # Add one or more +items+ to the set.
  #
  # Each item will be converted into a string and indexed upon adding.
  #
  # @param items [#to_s] item(s) to add
  # @return [FuzzySet] +self+
  def add(*items)
    items.each do |item|
      item = item.to_s
      return self if @items.include?(item)
      @items.push(item)
      id = @items.index(item)
      normalized = normalize(item)
      @denormalize[normalized] = item

      # ... calculate ngrams!
      normalized.ngram(NGRAM_SIZE).each do |gram|
        @index[gram] = (@index[gram] || []).push(id)
      end
    end
    self
  end

  # @see #add
  def <<(item)
    add(item)
  end

  def get(query)
    query = normalize(query)

    # check for exact match
    return [@denormalize[query]] if @denormalize[query]
    match_ids = query.ngram(NGRAM_SIZE).map { |ng| @index[ng] }
    match_ids = match_ids.flatten.compact.uniq
    match_ids.map { |id| @items[id] }
  end

  # @return [Boolean] +true+ if the given +item+ is present in the set.
  def include?(item)
    @items.include?(item)
  end

  # @return [Fixnum] Number of elements in the set.
  def length
    @items.length
  end
  alias :size :length

  private

  # Normalize a string by removing all non-word characters
  # except spaces and then converting it to lowercase.
  def normalize(str)
    str.gsub(/[^\w ]/, '').downcase
  end
end
