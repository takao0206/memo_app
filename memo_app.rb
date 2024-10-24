# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'
require 'pg'
require 'dotenv/load'

MEMOS_PATH = File.join(settings.public_folder, 'memos.json')
TABLE_NAME = 'memos'

def connect_db
  PG.connect(
    dbname: ENV['DATABASE_NAME'],
    user: ENV['DATABASE_USER'],
    password: ENV['DATABASE_PASSWORD']
  )
end

def create_table_if_not_exists
  connection = connect_db
  table_exists = connection.exec(
    "SELECT EXISTS (
      SELECT FROM information_schema.tables WHERE table_name = '#{TABLE_NAME}'
    );"
  ).first['exists'] == 't'

  return if table_exists

  connection.exec(
    "CREATE TABLE #{TABLE_NAME} (
      id SERIAL PRIMARY KEY,
      title VARCHAR(100) NOT NULL,
      content TEXT NOT NULL
    );"
  )
end

before do
  create_table_if_not_exists
end

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

def find_memo(memos, id)
  memos.find { |memo| memo['id'] == id }
end

get '/' do
  create_table_if_not_exists
  "Check your database! The table '#{TABLE_NAME}' has been created if it did not exist."
end

# TODO: データベース接続の機能が完成したので、次は保存先を JSON -> DB に変更する。
# get '/' do
#   save_memos([]) unless File.exist?(MEMOS_PATH)

#   @memos = load_memos
#   erb :index
# end

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
  @memo = find_memo(memos, params[:id])

  if @memo
    erb :memo
  else
    404
  end
end

get '/memos/:id/edit' do
  memos = load_memos
  @memo = find_memo(memos, params[:id])

  if @memo
    erb :edit
  else
    404
  end
end

patch '/memos/:id' do
  id = params[:id]
  new_title = params[:title]
  new_content = params[:content]

  memos = load_memos

  memo = find_memo(memos, id)
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
  erb :not_found
end
