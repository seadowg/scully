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

  def test_it_redirects_non_matching_search_result
    get "/episodes/search?name=not%20an%20episode"
    assert last_response.redirect?
    assert last_response["Location"].include? '/404'
  end

  def test_it_returns_next_episode_successfully
    get "/episodes/search?name=conduit"
    assert last_response.ok?
    assert last_response.body.include? "{\"episode\":\"Fallen Angel\"}"
  end
  
  def test_it_redirect_not_found_error_to_404
    get "/i_am_not_a_valid_route_hopefully"
    assert last_response.redirect?
    assert last_response["Location"].include? '/404'
  end

  def test_it_redirects_404_to_fbi_website
    get "/404"
    assert last_response.redirect?
    assert last_response["Location"].include? 'http://www.fbi.gov'
  end
end