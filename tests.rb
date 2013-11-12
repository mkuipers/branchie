ENV['RACK_ENV'] = 'test'

require './app'
require 'test/unit'
require 'rack/test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def branches
    { "test-name" => ['repo1/branch-one', 'repo2/branch-two', 'repo3/branch-three'] }
  end

  def test_it_says_hello_world
    get '/'
    assert last_response.ok?
  end

  def test_post
    post '/branch-set', format: :json, name: 'test-name', branches: branches["test-name"]
    assert last_response.ok?
  end

  def test_get
    get '/test-name', format: :json
    assert last_response.ok?
    assert_equal branches, JSON.parse(last_response.body)
  end
end