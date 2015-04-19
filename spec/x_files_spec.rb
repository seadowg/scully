require './app/x_files'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class XFilesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    XFiles
  end

  def test_it_returns_index_sucessfully
    get '/'
    assert last_response.ok?
  end

  def test_it_returns_matching_search_result_successfully
    get "/episodes/search?name=conduit"
    assert last_response.ok?
    assert last_response.body.include? "{\"next\":\"Fallen Angel\"}"
  end

  def test_it_returns_non_matching_search_result_error
    get "/episodes/search?name=not%20an%20episode"
    assert_equal(404, last_response.status)
  end
end
