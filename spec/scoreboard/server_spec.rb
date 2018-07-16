require 'rspec'
require 'rack/test'

describe Scoreboard::Server do
  include Rack::Test::Methods

  subject(:app) { described_class.new(Cricinfo::Adapter.new).setup_rack }

  let(:response) { get '/' }

  it 'mounts the application to the root path' do
    expect(response).to be_ok
    expect(response.body).to have_tag('title', text: 'Cricket Scoreboard')
  end
end
