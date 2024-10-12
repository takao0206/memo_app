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

get '/' do
  unless File.exist?(MEMOS_PATH)
    File.open(MEMOS_PATH, 'w') do |file|
      file.write([].to_json)
    end
  end

  memos = JSON.parse(File.read(MEMOS_PATH))
  erb :index, locals: { memos: }
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  id = SecureRandom.uuid
  title = params[:title]
  content = params[:content]

  memo = { id:, title:, content: }

  memos = JSON.parse(File.read(MEMOS_PATH))
  memos << memo

  File.open(MEMOS_PATH, 'w') do |file|
    file.write(JSON.pretty_generate(memos))
  end

  redirect '/'
end

get '/memos/:id' do
  memos = JSON.parse(File.read(MEMOS_PATH))
  memo = memos.find { |m| m['id'] == params[:id] }

  if memo
    erb :memo, locals: { memo: }
  else
    status 404
    erb :not_found
  end
end

get '/memos/:id/edit' do
  memos = JSON.parse(File.read(MEMOS_PATH))
  memo = memos.find { |m| m['id'] == params[:id] }

  erb :edit, locals: { memo: }
end

patch '/memos/:id' do
  id = params[:id]
  new_title = params[:title]
  new_content = params[:content]

  memos = JSON.parse(File.read(MEMOS_PATH))

  memo = memos.find { |m| m['id'] == id }
  memo['title'] = new_title if memo
  memo['content'] = new_content if memo

  File.open(MEMOS_PATH, 'w') do |file|
    file.write(JSON.pretty_generate(memos))
  end

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  id = params[:id]
  memos = JSON.parse(File.read(MEMOS_PATH))

  memos.reject! { |m| m['id'] == id }

  File.open(MEMOS_PATH, 'w') do |file|
    file.write(JSON.pretty_generate(memos))
  end

  redirect '/'
end

not_found do
  status 404
  erb :not_found
end
