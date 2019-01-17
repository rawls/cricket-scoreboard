require 'rspec'
require 'rack/test'

describe Scoreboard::Server do
  include Rack::Test::Methods

  subject(:server) { described_class.new(Cricinfo::Adapter.new, logger: Logger.new(nil)) }

  describe '#setup_rack' do
    let(:app)      { server.setup_rack }
    let(:response) { get '/' }

    it 'mounts the application to the root path' do
      expect(response).to be_ok
      expect(response.body).to have_tag('title', text: 'Cricket Scoreboard')
    end
  end

  describe '#start' do
    let(:expected_params) do
      {
        app: server.dispatch,
        server: server.server,
        Host: server.host,
        Port: server.port,
        AccessLog: server.logger
      }
    end

    before do
      allow(Rack::Server).to receive(:start)
      server.setup_rack
      server.start
    end

    it 'starts the rack server with the provided config' do
      expect(Rack::Server).to have_received(:start).with(expected_params)
    end
  end
end
