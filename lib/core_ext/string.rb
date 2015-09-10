class String
  # break apart the string into strings of length `n`
  #
  # @example
  #     'foobar'.ngram(3)
  #     # => ["-fo", "foo", "oob", "oba", "bar", "ar-"]
  def ngram(n)
    fail ArgumentError, "n must be >= 1, is #{n}" if n < 1
    str = "-#{self}-"
    (str.length - n + 1).times.map do |i|
      str.slice(i, n)
    end
  end
end
