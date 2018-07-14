def match_json(match_id)
  JSON.parse(File.open(fixture_folder + 'matches/' + match_id + '.json', 'rb').read)
end

def fixture_folder
  File.dirname(__FILE__) + '/../fixtures/cricinfo/'
end
