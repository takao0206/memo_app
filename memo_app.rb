# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'
require 'pg'
require 'dotenv/load'

TABLE_NAME = 'memos'
COLUMN_TITLE = 'title'
COLUMN_CONTENT = 'content'

before do
  create_table_if_not_exists
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def connect_db
  PG.connect(
    dbname: ENV['DATABASE_NAME'],
    user: ENV['DATABASE_USER'],
    password: ENV['DATABASE_PASSWORD']
  )
end

def with_connection
  connection = connect_db
  yield(connection)
ensure
  connection&.close
end

def create_table_if_not_exists
  with_connection do |connection|
    table_exists = connection.exec(
      "SELECT EXISTS (
        SELECT FROM information_schema.tables WHERE table_name = '#{TABLE_NAME}'
      );"
    ).first['exists'] == 't'

    unless table_exists
      connection.exec(
        "CREATE TABLE #{TABLE_NAME} (
          id SERIAL PRIMARY KEY,
          #{COLUMN_TITLE} VARCHAR(100) NOT NULL,
          #{COLUMN_CONTENT} TEXT NOT NULL
        );"
      )
    end
  end
end

def load_memos
  with_connection do |connection|
    @memos = connection.exec("SELECT * FROM #{TABLE_NAME} ORDER BY id ASC;").map do |memo|
      memo['title'].force_encoding('UTF-8')
      memo['content'].force_encoding('UTF-8')
      memo
    end
  end
  @memos
end

def save_memo(title, content)
  with_connection do |connection|
    connection.exec_params(
      "INSERT INTO #{TABLE_NAME} (#{COLUMN_TITLE}, #{COLUMN_CONTENT}) VALUES ($1, $2)", [title, content]
    )
  end
end

def update_memo(id, title, content)
  with_connection do |connection|
    connection.exec_params(
      "UPDATE #{TABLE_NAME} SET #{COLUMN_TITLE} = $1, #{COLUMN_CONTENT} = $2 WHERE id = $3", [title, content, id]
    )
  end
end

def delete_memo(id)
  with_connection do |connection|
    connection.exec_params("DELETE FROM #{TABLE_NAME} WHERE id = $1", [id])
  end
end

def find_memo(memos, id)
  memos.find { |memo| memo['id'] == id }
end

get '/' do
  load_memos

  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  save_memo(params[:title], params[:content])

  redirect '/'
end

get '/memos/:id' do
  @memo = find_memo(load_memos, params[:id])

  if @memo
    erb :memo
  else
    404
  end
end

get '/memos/:id/edit' do
  @memo = find_memo(load_memos, params[:id])

  if @memo
    erb :edit
  else
    404
  end
end

patch '/memos/:id' do
  id = params[:id]

  update_memo(id, params[:title], params[:content])

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  delete_memo(params[:id])

  redirect '/'
end

not_found do
  erb :not_found
end
