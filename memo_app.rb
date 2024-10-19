# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'

MEMOS_PATH = File.join(settings.public_folder, 'memos.json')

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def load_memos
  JSON.parse(File.read(MEMOS_PATH))
end

def save_memos(memos)
  File.open(MEMOS_PATH, 'w') do |file|
    file.write(JSON.generate(memos))
  end
end

get '/' do
  save_memos([]) unless File.exist?(MEMOS_PATH)

  memos = load_memos
  erb :index, locals: { memos: }
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memo = {
    id: SecureRandom.uuid,
    title: params[:title],
    content: params[:content]
  }

  memos = load_memos
  memos << memo

  save_memos(memos)

  redirect '/'
end

get '/memos/:id' do
  memos = load_memos
  memo = memos.find { |m| m['id'] == params[:id] }

  if memo
    erb :memo, locals: { memo: }
  else
    status 404
    erb :not_found
  end
end

get '/memos/:id/edit' do
  memos = load_memos
  memo = memos.find { |m| m['id'] == params[:id] }

  erb :edit, locals: { memo: }
end

patch '/memos/:id' do
  id = params[:id]
  new_title = params[:title]
  new_content = params[:content]

  memos = load_memos

  memo = memos.find { |m| m['id'] == id }
  if memo
    memo['title'] = new_title
    memo['content'] = new_content
  end

  save_memos(memos)

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  memos = load_memos

  memos.reject! { |m| m['id'] == params[:id] }

  save_memos(memos)

  redirect '/'
end

not_found do
  status 404
  erb :not_found
end
