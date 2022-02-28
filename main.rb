
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg' 
require 'bcrypt' 
require 'cloudinary'

# cloudinary_options = { # this is for cloudinary to allow the storing of pictures 
#   cloud_name: 'dciyilvza',
#   api_key: ENV['CLOUDINARY_API_KEY'],
#   api_secret: ENV['CLOUDINARY_API_SECRET']
# }

enable :sessions #to create a login session for the user

def logged_in?()
  if session[:user_id]
    return true
  else
    return false
  end
end

def loggedin_user()
  conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})

  sql = "select * from users where id = #{session[:user_id]}"
  result = conn.exec(sql)
  user = result.first
  conn.close
  return user
end

def db_query(sql, params = [])
  conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
  result = conn.exec_params(sql, params)
  conn.close
  return result
end

# def create_moment(name, image_url, text, like_count)
#   db_query("INSERT INTO posts (name, image_url, text, like_count) VALUES ($1, $2, $3, $4)", [name, image_url, text, like_count])
# end

# def delete_moment(id)
#   sql = "DELETE FROM posts WHERE id = $1;"
#   db_query(sql, [id])
# end

require_relative "controllers/signup.rb"
require_relative "controllers/login.rb"
require_relative "controllers/logout.rb"
require_relative "controllers/error.rb"
require_relative "controllers/post.rb"
require_relative "controllers/user.rb"
require_relative "controllers/comment.rb"

get '/' do
  if logged_in?
    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
    sql = "select * from users where id = #{session[:user_id]};"
    user = conn.exec(sql)[0]
    conn.close
  end

  conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
  sql2 = "select users.id as user_id, * from users full join posts on users.id = posts.user_id order by posts.id DESC;"
  results = conn.exec_params(sql2)

  conn.close

  erb(:index, locals: {
    user: user,
    results: results
    })
end

