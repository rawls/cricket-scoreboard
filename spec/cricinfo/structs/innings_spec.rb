describe Cricinfo::Structs::Innings do
  describe '#parse' do
    subject(:innings) { described_class.parse(teams, inningsj) }

    context 'when building the Rose Bowl' do
      let(:inningsj)      { match_json('1')['innings'].detect { |innings| innings['innings_number'] == '1' } }
      let(:batting_team)  { Cricinfo::Structs::Team.new(id: '1102', name: 'Hampshire') }
      let(:fielding_team) { Cricinfo::Structs::Team.new(id: '1479', name: 'Warwickshire') }
      let(:teams)         { { batting_team.id => batting_team, fielding_team.id => fielding_team } }

      it 'sets the batting_team' do
        expect(innings.batting_team).to eq(batting_team)
      end

      it 'sets the fielding team' do
        expect(innings.fielding_team).to eq(fielding_team)
      end

      it 'sets the runs' do
        expect(innings.runs).to eq(48)
      end

      it 'sets the ball count' do
        expect(innings.balls).to eq(107)
      end

      it 'sets the wicket count' do
        expect(innings.wickets).to eq(3)
      end
    end
  end
end
