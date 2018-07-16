require 'spec_helper'

describe Scoreboard::App do
  include Rack::Test::Methods

  subject(:app) do
    described_class.set(:cricinfo, adapter)
    described_class.new
  end

  let(:adapter) { Cricinfo::Adapter.new }

  context 'when GET /' do
    let(:response) { get '/' }

    it 'returns a successful response' do
      expect(response).to be_ok
    end

    it 'contains a mini-scoreboard for the 1st match' do
      expect(response.body).to have_tag("a[href='/scoreboard/1-Hampshire-v-Warwickshire']") do
        with_tag('#match-1-home-team', text: 'Hampshire')
        with_tag('#match-1-away-team', text: 'Warwickshire')
        with_tag('#match-1-ground',    text: '@ Southampton')
      end
    end

    it 'contains a mini-scoreboard for the 2nd match' do
      expect(response.body).to have_tag("a[href='/scoreboard/2-England-v-South-Africa']") do
        with_tag('#match-2-home-team', text: 'England')
        with_tag('#match-2-away-team', text: 'South Africa')
        with_tag('#match-2-ground',    text: '@ Leeds')
      end
    end

    it 'contains a mini-scoreboard for the 3rd match' do
      expect(response.body).to have_tag("a[href='/scoreboard/3-Hampshire-v-Warwickshire']") do
        with_tag('#match-3-home-team', text: 'Hampshire')
        with_tag('#match-3-away-team', text: 'Warwickshire')
        with_tag('#match-3-ground',    text: '@ Southampton')
      end
    end

    it 'contains a mini-scoreboard for the 4th match' do
      expect(response.body).to have_tag("a[href='/scoreboard/4-Hampshire-v-Warwickshire']") do
        with_tag('#match-4-home-team', text: 'Hampshire')
        with_tag('#match-4-away-team', text: 'Warwickshire')
        with_tag('#match-4-ground',    text: '@ Southampton')
      end
    end

    it 'contains a mini-scoreboard for the 5th match' do
      expect(response.body).to have_tag("a[href='/scoreboard/5-Sussex-v-Durham']") do
        with_tag('#match-5-home-team', text: 'Sussex')
        with_tag('#match-5-away-team', text: 'Durham')
        with_tag('#match-5-ground',    text: '@ Hove')
      end
    end
  end

  context 'when GET /scoreboard/5-foo-bar' do
    let(:response) { get '/scoreboard/5-foo-bar' }
    let(:match)    { adapter.match('5') }

    it 'returns a successful response' do
      expect(response).to be_ok
    end

    it 'contains the run total' do
      expect(response.body).to have_tag('#total-runs', text: match.runs)
    end

    it 'contains the 1st batsman\'s name' do
      expect(response.body).to have_tag('#first-batsman-name', text: match.batsmen.first.surname)
    end

    it 'contains the 1st batsman\'s score' do
      expect(response.body).to have_tag('#first-batsman-runs', text: match.batsmen.first.runs)
    end

    it 'contains the 2nd batsman\'s name' do
      expect(response.body).to have_tag('#second-batsman-name', text: match.batsmen.last.surname)
    end

    it 'contains the 2nd batsman\'s score' do
      expect(response.body).to have_tag('#second-batsman-runs', text: match.batsmen.last.runs)
    end

    it 'contains the number of overs' do
      expect(response.body).to have_tag('#overs', text: match.overs)
    end

    it 'contains the number of wickets' do
      expect(response.body).to have_tag('#wickets', text: match.wickets)
    end

    it 'contains the run rate' do
      expect(response.body).to have_tag('#run-rate', text: match.run_rate)
    end

    it 'contains the home team\'s 1st innings score' do
      expect(response.body).to have_tag('#home-innings-1', text: /#{match.home_innings.first.summary}/)
    end

    it 'contains the home team\'s 2nd innings score' do
      expect(response.body).to have_tag('#home-innings-2', text: /-/)
    end

    it 'contains the away team\'s 1st innings score' do
      expect(response.body).to have_tag('#away-innings-1', text: /#{match.away_innings.first.summary}/)
    end

    it 'contains the away team\'s 2nd innings score' do
      expect(response.body).to have_tag('#away-innings-2', text: /#{match.away_innings.last.summary}/)
    end

    it 'contains the details of the last six balls played' do
      expect(match.balls.size).to eq 6
      match.balls.each_with_index do |ball, i|
        expect(response.body).to have_tag("#ball-#{i}", text: /#{ball.over}.*#{ball.players}.*#{ball.event}/m)
      end
    end
  end

  context 'when GET /status' do
    let(:response) { get '/status' }
    let(:json)     { JSON.parse(response.body) }

    context 'when there are no matches' do
      it 'returns a successful response' do
        expect(response).to be_ok
      end

      it 'returns the correct cached at time' do
        expect(Time.parse(json['cached_at'])).to eq adapter.list_cached_at
      end
    end

    context 'when there are matches' do
      before do
        adapter.matches # Populate the cache
      end

      it 'returns a successful response' do
        expect(response).to be_ok
      end

      it 'returns the correct cached at time' do
        expect(json['cached_at']).to eq adapter.list_cached_at.strftime('%F %T')
      end
    end
  end

  context 'when requesting a file hosted in /public' do
    let(:response) { get '/favicon.ico' }

    it 'returns a successful response' do
      expect(response).to be_ok
    end
  end

  context 'when requesting an asset' do
    let(:response) { get '/assets/application.css' }

    it 'returns a successful response' do
      expect(response).to be_ok
    end
  end
end
