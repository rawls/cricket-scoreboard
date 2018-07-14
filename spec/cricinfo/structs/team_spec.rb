describe Cricinfo::Structs::Team do
  describe '#new' do
    context 'when creating the Hampshire county team' do
      subject(:team) { described_class.new(opts) }

      let(:opts) do
        {
          id: '1',
          name: 'Hampshire',
          short_name: 'Hants'
        }
      end

      it 'sets the id' do
        expect(team.id).to eq('1')
      end

      it 'sets the name' do
        expect(team.name).to eq('Hampshire')
      end

      it 'sets the short name' do
        expect(team.short_name).to eq('Hants')
      end
    end
  end

  describe '#parse' do
    subject(:team) { described_class.parse(teamj) }

    context 'when building team1 of Hants v Warks' do
      let(:teamj)  { match_json('1')['team'].first }

      it 'sets the name' do
        expect(team.name).to eq('Hampshire')
      end

      it 'sets the short name' do
        expect(team.short_name).to eq('Hants')
      end

      it 'sets the id' do
        expect(team.id).to eq('1102')
      end

      it 'sets the players' do
        expect(team.players.size).to eq(11)
        expect(team.players.values).to all(be_an(Cricinfo::Structs::Player))
      end
    end
  end
end
