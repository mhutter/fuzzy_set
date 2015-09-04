RSpec.describe FuzzySet do
  let(:fs) { FuzzySet.new }

  it 'has a version' do
    expect(FuzzySet::VERSION).to_not be_nil
  end

  it '#new takes initial elements' do
    set = FuzzySet.new('foo', 'bar')
    expect(set).to_not be_empty
    expect(set.length).to eq 2
  end

  context '#add' do
    it 'adds single items' do
      %w(foo bar baz).each do |word|
        fs.add word
        expect(fs).to include word
      end
    end

    it 'adds multiple items' do
      fs.add('foo', 'bar', 'baz')
      %w(foo bar baz).each { |word| expect(fs).to include word }
      expect(fs.length).to eq 3
    end

    it 'does not add duplicates' do
      fs.add 'foo', 'bar'
      expect(fs.length).to eq 2
      fs.add 'foo'
      expect(fs.length).to eq 2
    end

    it 'returns self' do
      expect(fs.add('something')).to eq fs
    end

    it 'converts to strings' do
      fs.add :symbol
      expect(fs).to_not include :symbol
      expect(fs).to include 'symbol'
    end
  end

  it '#<< calls #add' do
    expect(fs).to receive(:add).with 'item'
    fs << 'item'
  end

  context '#exact_match' do
    it 'returns nil if no match exists' do
      expect(fs.exact_match('Foo')).to be_nil
    end

    it 'returns the normalized/denormalized match' do
      fs.add 'Foobar'
      expect(fs.exact_match('Foobar')).to eq 'Foobar'
      expect(fs.exact_match('foobar')).to eq 'Foobar'
      expect(fs.exact_match('FooBar!')).to eq 'Foobar'
    end
  end


  context '#get' do
    it 'finds stuff' do
      fs.add(*states)
      expect(fs.get('mischigen')).to include *['Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Wisconsin']
    end

    it 'returns an empty array if no matches are found' do
      expect(fs.get('something')).to eq []
    end

    it 'sorts results by similarity to query' do
      fs.add(*states)
      expect(fs.get('missipissi')).to eq ['Mississippi', 'Missouri', 'Michigan', 'Minnesota']
    end
  end


  context '#include?' do
    it 'returns true if an item has been added' do
      fs.add('foo')
      expect(fs).to include 'foo'
    end
    it 'returns false if an item has not been added' do
      fs.add('foo')
      expect(fs).to_not include 'bar'
    end
  end

  it '#empty? tells whether or not it has items' do
    expect(fs).to be_empty
    fs.add 'item'
    expect(fs).to_not be_empty
  end

  context '#length' do
    it 'returns 0 for a new object' do
      expect(fs.length).to eq 0
    end

    it 'returns the length' do
      fs.add 'foo'
      expect(fs.length).to eq 1
      fs.add 'bar'
      expect(fs.length).to eq 2
    end

    it 'is callable as #size' do
      expect(fs.size).to eq 0
    end
  end
end
