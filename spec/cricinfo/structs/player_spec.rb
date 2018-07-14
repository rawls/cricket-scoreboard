describe Cricinfo::Structs::Player do
  describe '#parse' do
    subject(:player) { described_class.parse(playerj) }

    context 'when building Michael Carberry' do
      let(:playerj) { match_json('1')['team'].first['player'].first }

      it 'sets his id' do
        expect(player.id).to eq('7823')
      end

      it 'sets his name' do
        expect(player.name).to eq('Michael Carberry')
      end

      it 'sets his date of birth' do
        expect(player.dob).to eq(Date.parse('1980-09-29'))
      end

      it 'sets his primary role' do
        expect(player.role).to eq('opening batsman')
      end

      it 'sets his batting style' do
        expect(player.batting_style).to eq('left-hand bat')
      end

      it 'sets his bowling style' do
        expect(player.bowling_style).to eq('right-arm offbreak ')
      end

      it 'does not set him as captain' do
        expect(player.captain).to be_falsy
      end
    end
  end

  describe '#add_batting_info' do
    subject(:player) do
      p = described_class.new
      p.add_batting_info(batsmanj)
      p
    end

    context 'when updating the first batsman in Hants v Warks' do
      let(:batsmanj) { match_json('1')['live']['batting'].first }

      it 'sets the runs' do
        expect(player.runs).to eq(15)
      end

      it 'sets the balls faced' do
        expect(player.balls_faced).to eq(44)
      end

      it 'sets the strike rate' do
        expect(player.strike_rate).to eq(34.1)
      end
    end
  end

  describe '#add_bowling_info' do
    subject(:player) do
      p = described_class.new
      p.add_bowling_info(bowlerj)
      p
    end

    context 'when updating the first bowler in Hants v Warks' do
      let(:bowlerj) { match_json('1')['live']['bowling'].first }

      it 'sets the number of wickets' do
        expect(player.wickets).to eq(1)
      end

      it 'sets the number of runs conceded' do
        expect(player.conceded).to eq(6)
      end

      it 'sets the overs bowled' do
        expect(player.overs).to eq(4.5)
      end

      it 'sets the bowler\'s economy' do
        expect(player.economy).to eq(1.2)
      end
    end
  end
end
