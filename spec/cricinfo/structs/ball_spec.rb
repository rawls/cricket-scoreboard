describe Cricinfo::Structs::Ball do
  describe '#parse' do
    subject(:ball) { described_class.parse(ballj) }

    context 'when building the Rose Bowl' do
      let(:ballj) { match_json('1')['comms'].first['ball'].first }

      it 'sets the over' do
        expect(ball.over).to eq(17.5)
      end

      it 'sets the players' do
        expect(ball.players).to eq('Rankin to Adams')
      end

      it 'sets the event' do
        expect(ball.event).to eq('no run')
      end

      it 'can summarize the ball' do
        expect(ball.summary).to eq('17.5: Rankin to Adams, no run')
      end
    end
  end
end
