require 'string/similarity'

require 'fuzzy_set/version'

# FuzzySet implements a fuzzy-searchable set of strings.
#
# As a set, it cannot contain duplicate elements.
class FuzzySet
  # default options for creating new instances
  DEFAULT_OPTS = {
    all_matches: false,
    ngram_size_max: 3,
    ngram_size_min: 2
  }

  # @param items [#each,#to_s] item(s) to add
  # @param opts [Hash] options, see {DEFAULT_OPTS}
  # @option opts [Boolean] :all_matches
  #   return all matches, even if an exact match is found
  # @option opts [Fixnum] :ngram_size_max upper limit for ngram sizes
  # @option opts [Fixnum] :ngram_size_min lower limit for ngram sizes
  def initialize(*items, **opts)
    opts = DEFAULT_OPTS.merge(opts)

    @items = []
    @denormalize = {}
    @index = {}
    @all_matches = opts[:all_matches]
    @ngram_size_max = opts[:ngram_size_max]
    @ngram_size_min = opts[:ngram_size_min]

    add(items)
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
  # @param items [#each,#to_s] item(s) to add
  # @return [FuzzySet] +self+
  def add(*items)
    items = [items].flatten
    items.each do |item|
      item = item.to_s
      return self if @items.include?(item)

      id = _add(item)
      calculate_grams_for(normalize(item), id)
    end
    self
  end

  # @see #add
  def <<(item)
    add(item)
  end

  # Fuzzy-find a string based on +query+
  #
  # 1. normalize +query+
  # 2. check for an exact match and return, if present
  # 3. find matches based on Ngrams
  # 4. sort matches by their cosine similarity to +query+
  #
  # @param query [String] search query
  def get(query)
    query = normalize(query)

    # check for exact match
    return [@denormalize[query]] if !@all_matches && @denormalize[query]

    match_ids = matches_for(query)
    match_ids = match_ids.flatten.compact.uniq
    matches = match_ids.map { |id| @items[id] }

    # sort matches by their cosine distance to query
    matches.sort_by { |match| 1.0 - String::Similarity.cosine(query, match) }
  end

  # @return [Boolean] +true+ if the given +item+ is present in the set.
  def include?(item)
    @items.include?(item)
  end

  # @return [Fixnum] Number of elements in the set.
  def length
    @items.length
  end
  alias_method :size, :length

  # @return [Boolean] +true+, if there are no items yet.
  def empty?
    @items.empty?
  end

  private

  def matches_for(query)
    @ngram_size_max.downto(@ngram_size_min).each do |size|
      match_ids = ngram(query, size).map { |ng| @index[ng] }
      return match_ids if match_ids.any?
    end
    []
  end

  # Normalize a string by removing all non-word characters
  # except spaces and then converting it to lowercase.
  def normalize(str)
    str.gsub(/[^\w ]/, '').downcase
  end

  def _add(item)
    @items.push(item)
    normalized = normalize(item)
    @denormalize[normalized] = item
    @items.index(item)
  end

  # calculate Ngrams and add them to the items
  def calculate_grams_for(string, id)
    @ngram_size_max.downto(@ngram_size_min).each do |size|
      ngram(string, size).each do |gram|
        @index[gram] = (@index[gram] || []).push(id)
      end
    end
  end

  # break apart the string into strings of length `n`
  #
  # @example
  #     'foobar'.ngram(3)
  #     # => ["-fo", "foo", "oob", "oba", "bar", "ar-"]
  def ngram(str, n)
    fail ArgumentError, "n must be >= 1, is #{n}" if n < 1
    str = "-#{str}-" if n > 1
    (str.length - n + 1).times.map do |i|
      str.slice(i, n)
    end
  end
end
