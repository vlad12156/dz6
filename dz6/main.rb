$stdout.sync = true

require 'sinatra'
require 'mongo'
require './lib/posts_storage'
require './lib/contacts_storage'
require './lib/faq_storage'

set :views, settings.root + '/templates'

connection = Mongo::Client.new(['rpiserver.tk'], database: 'blog')

posts_storage = Posts.new(connection)
contacts_storage = Contacts.new(connection)
faq_storage = FAQ.new(connection)

get '/' do
  erb :welcome
end

get '/faq' do
puts faq_storage.all
  faqs = faq_storage.all
  erb :faqs, locals: { faqs: faqs }
end

get "/contacts" do
  contacts = contacts_storage.all
  erb :contacts, locals: { contacts: contacts }
end

get '/posts' do
puts posts_storage.all
  posts = posts_storage.all
  erb :list, locals: { posts: posts }
end

get '/posts/:id' do
  post = posts_storage.find(params[:id])
  erb :post, locals: { post: post }
end

get '/faq/:id' do
  faq_item = faq_storage.find(params[:id])
  erb :faq, locals: { faqs: faq_item }
end

get '/create/posts' do
  erb :post_create
end

get '/create/contacts' do
  erb :contact_create
end

get '/create/faq' do
  erb :faq_create
end

post '/posts' do
  posts_storage.create(params[:title], params[:text])
  redirect to('/posts')
end

post '/contacts' do
  contacts_storage.create(params[:name], params[:email])
  redirect to('/contacts')
end

post '/faq' do
  faq_storage.create(params[:title], params[:text])
  redirect to('/faq')
end