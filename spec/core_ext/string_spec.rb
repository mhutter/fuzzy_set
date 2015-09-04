RSpec.describe String do
  context '#ngram' do
    it 'creates ngrams of various sizes' do
      expect('foo'.      ngram(2)).to eq %w(-f fo oo o-)
      expect('behaviour'.ngram(3)).to eq %w(-be beh eha hav avi vio iou our ur-)
      expect('foobar'.   ngram(4)).to eq %w(-foo foob ooba obar bar-)
    end
  end
end
