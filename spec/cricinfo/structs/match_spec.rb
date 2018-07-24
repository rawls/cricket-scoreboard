describe Cricinfo::Structs::Match do
  let(:json) { match_json('1') }

  describe '#new' do
    subject(:match) { described_class.new('2018-05-01', '2018-05-06', 'The Ashes') }

    it 'sets the start_date' do
      expect(match.start_date).to eq Date.parse('2018-05-01')
    end

    it 'sets the end_date' do
      expect(match.end_date).to eq Date.parse('2018-05-06')
    end

    it 'sets the series' do
      expect(match.series).to eq 'The Ashes'
    end
  end

  describe '#parse' do
    context 'when given JSON for a county test match between Hampshire & Warwickshire' do
      subject(:match) { described_class.parse(json) }

      it 'sets the start_date' do
        expect(match.start_date).to eq Date.parse('2017-06-02')
      end

      it 'sets the end_date' do
        expect(match.end_date).to eq Date.parse('2017-06-05')
      end

      it 'sets the series' do
        expect(match.series).to eq 'County DIV One'
      end

      it 'sets the ground\'s name' do
        expect(match.ground.name).to eq('The Rose Bowl, Southampton')
      end

      it 'sets the home team' do
        expect(match.home_team.name).to eq('Hampshire')
      end

      it 'sets the away team' do
        expect(match.away_team.name).to eq('Warwickshire')
      end

      it 'sets the teams' do
        expect(match.teams.size).to eq(2)
        expect(match.teams.keys).to include('1102')
        expect(match.teams.keys).to include('1479')
      end

      it 'sets the home team players' do
        expect(match.home_team.players.size).to eq(11)
        expect(match.home_team.players.values).to all(be_an(Cricinfo::Structs::Player))
      end

      it 'sets the away team players' do
        expect(match.away_team.players.size).to eq(11)
        expect(match.away_team.players.values).to all(be_an(Cricinfo::Structs::Player))
      end

      it 'sets the innings' do
        expect(match.innings.size).to eq(1)
        expect(match.innings).to all(be_an(Cricinfo::Structs::Innings))
      end

      it 'sets the wickets' do
        expect(match.wickets).to eq(3)
      end

      it 'sets the overs' do
        expect(match.overs).to eq(17.5)
      end

      it 'sets the run rate' do
        expect(match.run_rate).to eq(2.7)
      end

      it 'sets the target' do
        expect(match.target).to be_nil
      end

      it 'sets the break' do
        expect(match.break).to eq('Day 1')
      end

      it 'sets the balls' do
        expect(match.balls.size).to eq(6)
        expect(match.balls).to all(be_an(Cricinfo::Structs::Ball))
      end

      it 'can describe the most recent ball' do
        expect(match.balls.first.summary).to eq('17.5: Rankin to Adams, no run')
      end

      it 'sets the batsmen' do
        expect(match.batsmen.size).to eq(2)
      end

      it 'sets the bowlers' do
        expect(match.bowlers.size).to eq(2)
      end
    end
  end
end
