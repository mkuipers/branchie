require 'sinatra'
require 'redis'
require 'json'

redis = Redis.new

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def random_string(length)
    rand(36**length).to_s(36)
  end

  def check_params?
    params[:branches]         &&
    !params[:branches].empty? &&
    params[:name]             &&
    !params[:name].empty?
  end
end

get '/' do
  content_type :json
  'hello-world'.to_json
end

post '/branch-set' do
  content_type :json
  if check_params?
    @name = params[:name]
    @branches = params[:branches]
    redis.set "branch-set:#{@name}", @branches
  end
  { @name => @branches }.to_json
end

get '/:name' do
  content_type :json
  @branches = redis.get "branch-set:#{params[:name]}"
  { params[:name] => @branches }.to_json
end
