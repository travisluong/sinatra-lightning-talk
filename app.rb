require 'sinatra'
require 'haml'
require 'data_mapper'

enable :sessions

DataMapper::setup(:default, ENV["HEROKU_POSTGRESQL_COBALT_URL"] || "sqlite3://#{Dir.pwd}/sinatra.db")

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  haml :home
end

get '/about' do
  haml :about
end

get '/song' do
  songs = [:fly_me_to_the_moon, :my_way, :strangers_in_the_night]
  haml songs.sample
end

get '/comment' do
  @comments = Comment.all :order => :id.desc
  haml :comment
end

post '/comment' do
  c = Comment.new
  c.content = params[:content]
  c.created_at = Time.now
  c.updated_at = Time.now
  c.save
  redirect '/comment'
end

get '/success' do
  haml :success
end
