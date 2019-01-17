describe Configuration do
  context 'when running in a container' do
    subject(:config) { described_class.parse('foo.yml') }

    before do
      ENV['CONTAINER'] = 'true'
      allow(described_class).to receive(:from_environment).and_call_original
    end

    context 'when no environment variables have been set' do
      let(:defaults) do
        {
          log_level: 'INFO',
          webserver: {
            server: 'thin',
            host: '0.0.0.0',
            port: 4567,
            interval: 150,
            tracking_id: nil
          },
          cricinfo: {
            list_url: 'http://static.cricinfo.com/rss/livescores.xml',
            match_url: 'http://www.espncricinfo.com/ci/engine/match/',
            list_cache_expiry: 3600,
            match_cache_expiry: 120
          }
        }
      end

      it 'loads the configuration from the environment' do
        config
        expect(described_class).to have_received(:from_environment)
      end

      it 'uses the default configuration' do
        expect(config).to eq defaults
      end
    end

    context 'when environment variables have been set' do
      let(:expected) do
        {
          log_level: 'DEBUG',
          webserver: {
            server: 'thin',
            host: '0.0.0.0',
            port: 4568,
            interval: 123,
            tracking_id: nil
          },
          cricinfo: {
            list_url: 'http://example.com/list',
            match_url: 'http://example.com/match',
            list_cache_expiry: 9999,
            match_cache_expiry: 999
          }
        }
      end

      before do
        ENV['LOG_LEVEL']          = 'DEBUG'
        ENV['PORT']               = '4568'
        ENV['REFRESH_INTERVAL']   = '123'
        ENV['LIST_URL']           = 'http://example.com/list'
        ENV['MATCH_URL']          = 'http://example.com/match'
        ENV['LIST_CACHE_EXPIRY']  = '9999'
        ENV['MATCH_CACHE_EXPIRY'] = '999'
      end

      after do
        %w[LOG_LEVEL PORT REFRESH_INTERVAL LIST_URL MATCH_URL LIST_CACHE_EXPIRY MATCH_CACHE_EXPIRY].each do |var|
          ENV[var] = nil
        end
      end

      it 'Sets provided variables correctly and uses defaults for other values' do
        expect(config).to eq(expected)
      end
    end
  end
end
