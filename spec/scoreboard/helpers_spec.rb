describe Scoreboard::Helpers do
  subject do
    Class.new { include Scoreboard::Helpers }.new
  end

  describe '#cached_at' do
    context 'when no caches exist' do
      let(:cached_at) { subject.cached_at }

      it 'returns the start of the epoc' do
        expect(cached_at).to eq Time.parse('1970-01-01 00:00:00')
      end
    end
  end
end
