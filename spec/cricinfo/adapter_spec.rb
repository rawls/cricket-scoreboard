describe Cricinfo::Adapter do
  describe '#matches' do
    context 'with five cricket matches available' do
      subject(:adapter) { described_class.new }

      let(:matches)         { adapter.matches }
      let(:hants_v_warks)   { '1' }
      let(:eng_v_sa)        { '2' }
      let(:hants_v_warks2)  { '3' }
      let(:hants_v_warks3)  { '4' }
      let(:sussex_v_durham) { '5' }

      before do
        adapter.matches
      end

      it 'stores England v South Africa' do
        expect(adapter.match(eng_v_sa)).not_to be_nil
        expect(adapter.match(eng_v_sa).home_team.name).to eq('England')
        expect(adapter.match(eng_v_sa).away_team.name).to eq('South Africa')
      end

      it 'stores Hants v Warks' do
        expect(adapter.match(hants_v_warks)).not_to be_nil
        expect(adapter.match(hants_v_warks).home_team.name).to eq('Hampshire')
        expect(adapter.match(hants_v_warks).away_team.name).to eq('Warwickshire')
      end

      it 'stores Hants v Warks 2' do
        expect(adapter.match(hants_v_warks2)).not_to be_nil
        expect(adapter.match(hants_v_warks2).home_team.name).to eq('Hampshire')
        expect(adapter.match(hants_v_warks2).away_team.name).to eq('Warwickshire')
      end

      it 'stores Hants v Warks 3' do
        expect(adapter.match(hants_v_warks3)).not_to be_nil
        expect(adapter.match(hants_v_warks3).home_team.name).to eq('Hampshire')
        expect(adapter.match(hants_v_warks3).away_team.name).to eq('Warwickshire')
      end

      it 'stores Sussex v Durham' do
        expect(adapter.match(sussex_v_durham)).not_to be_nil
        expect(adapter.match(sussex_v_durham).home_team.name).to eq('Sussex')
        expect(adapter.match(sussex_v_durham).away_team.name).to eq('Durham')
      end
    end
  end
end
