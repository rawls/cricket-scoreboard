describe Cricinfo::Structs::Ground do
  describe '#new' do
    context 'when given opts for the rose bowl' do
      subject(:ground) { described_class.new(opts) }

      let(:opts) do
        {
          name: 'Rose Bowl',
          short_name: 'Rose',
          latitude: 123.0,
          longitude: 456.0
        }
      end

      it 'sets the name' do
        expect(ground.name).to eq('Rose Bowl')
      end

      it 'sets the short_name' do
        expect(ground.short_name).to eq('Rose')
      end

      it 'sets the latitude' do
        expect(ground.latitude).to eq(123.0)
      end

      it 'sets the longitude' do
        expect(ground.longitude).to eq(456.0)
      end
    end
  end

  describe '#parse' do
    subject(:ground) { described_class.parse(matchj) }

    context 'when building the Rose Bowl' do
      let(:matchj) { match_json('1')['match'] }

      it 'sets the name' do
        expect(ground.name).to eq('The Rose Bowl, Southampton')
      end

      it 'sets the short name' do
        expect(ground.short_name).to eq('Southampton')
      end

      it 'sets the latitude' do
        expect(ground.latitude).to eq(50.9)
      end

      it 'sets the longitude' do
        expect(ground.longitude).to eq(-1.3)
      end
    end

    context 'when attempting to parse invalid incomplete JSON' do
      let(:matchj) { {} }

      it 'returns nil' do
        expect(ground).to be_nil
      end
    end
  end
end
