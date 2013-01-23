require './x_files'
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

  def test_it_redirects_matching_search_result
    get '/episodes/search?name=pilot'
    assert last_response.redirect?
    assert last_response["Location"].include? '/episodes/1/next'

    get '/episodes/search?name=The%20List'
    assert last_response.redirect?
    assert last_response["Location"].include? '/episodes/54/next'
  end

  def test_it_redirects_non_matching_search_result
    get "/episodes/search?name=not%20an%20episode"
    assert last_response.redirect?
    assert last_response["Location"].include? '/404'
  end

  def test_it_returns_next_episode_successfully
    get "/episodes/2/next"
    assert last_response.ok?
    assert last_response.body.include? 'Fallen Angel'
  end
end