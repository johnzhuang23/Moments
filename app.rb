require 'sinatra'
require 'sinatra/reloader'
require 'pg' 
require 'bcrypt'
require 'pry'

enable :sessions

def logged_in?()
  if session[:user_id]
    return true
  else
    return false
  end
end

def loggedin_user()
  conn = PG.connect(dbname: 'dating_app')
  sql = "select * from users where id = #{session[:user_id]}"
  result = conn.exec(sql)
  user = result.first
  conn.close
  return user
end

def db_query(sql, params = [])
  conn = PG.connect(dbname: 'dating_app')
  result = conn.exec_params(sql, params)
  conn.close
  return result
end

def create_moment(name, image_url, text, like_count)
  db_query("INSERT INTO moments (name, image_url, text, like_count) VALUES ($1, $2, $3, $4)", [name, image_url, text, like_count])
end

def delete_moment(id)
  sql = "DELETE FROM moments WHERE id = $1;"
  db_query(sql, [id])
end


# USER SIGN UP
get '/signup' do
  erb(:signup)
end

post '/signup' do
  params.to_s

  password = params["password"]
  email = params["email"]
  conn = PG.connect(dbname: 'dating_app')
  password_digest = BCrypt::Password.create(password)
  sql = "insert into users (email, password_digest) values ('#{email}', '#{password_digest}');"
  conn.exec(sql)

  session[:user_id]=conn.exec("select * from users where email = '#{email}';")[0]['id']
  conn.close
  redirect "/users/#{session[:user_id]}/edit"


end

# USER LOG IN
get '/login' do
  erb(:login)
end

post '/login' do
  params.to_s
  username = params["username"]
  password = params["password"]
  email = params["email"]
  
  conn = PG.connect(dbname: 'dating_app')
  sql = "select * from users where email = '#{email}';"
  result = conn.exec(sql)
  conn.close
  
  if result.count > 0 && BCrypt::Password.new(result[0]['password_digest']).==(password)
    session[:user_id] = result[0]['id']
    redirect "/"
  else
    redirect '/error'
  end
end

get '/error' do
  erb( :error)
end

# USER LOG OUT
delete '/login' do
  session[:user_id] = nil
  redirect "/"
end

get '/' do
  if logged_in?
    conn = PG.connect(dbname: 'dating_app')
    sql = "select * from users where id = #{session[:user_id]};"
    user = conn.exec(sql)[0]
    conn.close
  end

  conn = PG.connect(dbname: 'dating_app')
  sql = "select users.id as user_id, * from users full join moments on users.email = moments.email order by moments.id DESC;"
  results = conn.exec_params(sql)
  # binding.pry

  conn.close

  erb(:index, locals: {
    user: user,
    results: results
    # userpage: userpage
    })
end

get '/moments/new' do
  
  conn = PG.connect(dbname: 'dating_app')
    sql = "select * from users where id = #{session[:user_id]};"
    user = conn.exec(sql)[0]
    conn.close

  erb(:new, locals: {
    user: user
  })
  
end

# SHOW
get '/users/:id' do
  user_id = params["id"]
  conn = PG.connect(dbname: 'dating_app')
  users = conn.exec("SELECT * FROM users where id=#{user_id};")
  user = users[0]
  conn.close

  erb(:user_detail, locals: {
  user: user
  })
end

get '/mymoments' do

  conn = PG.connect(dbname: 'dating_app')

  user_id = params["id"]
  users = conn.exec("SELECT * FROM users where id=#{loggedin_user()["id"]};")
  user = users[0]

  sql = "select * from users full join moments on users.email = moments.email where users.id= '#{loggedin_user()["id"]}' order by moments.id DESC;"
  usermoments = conn.exec(sql)
  conn.close

  erb( :user_moments_edit, locals: {
    usermoments: usermoments,
    user: user
  })

end

get '/users/:id/moments' do

  conn = PG.connect(dbname: 'dating_app')

  user_id = params["id"]
  users = conn.exec("SELECT * FROM users where id=#{user_id};")
  user = users[0]

  sql = "select * from users full join moments on users.email = moments.email where users.id= '#{params["id"]}' order by moments.id DESC;"
  usermoments = conn.exec(sql)
  conn.close

  erb( :user_moments_display, locals: {
    usermoments: usermoments,
    user: user
  })
end


# CREATE
post '/moments' do
  params.to_s
  if logged_in?
    conn = PG.connect(dbname: 'dating_app')
    sql = "insert into moments (image_url, user_text, email) values ('#{params['image_url']}', '#{params['user_text']}', '#{loggedin_user()["email"]}');"
    result = conn.exec_params(sql)
    conn.close
  end
  redirect '/'
end


# EDIT
get '/users/:id/edit' do
  user = db_query("select * from users where id = $1", [params['id']])[0]
  erb(:edit,locals: {
    user: user
    })
end
  
# UPDATE
put '/users/:id' do
  
  sql = "UPDATE users SET user_name = '#{params['name']}', user_avatar_url = '#{params['user_avatar_url']}' WHERE id = '#{params['id']}';"

  conn = PG.connect(dbname: 'dating_app')
  conn.exec(sql)
  conn.close

  redirect "/users/#{params['id']}"
  
end

# DELETE
delete '/moments/:id/delete' do

  conn = PG.connect(dbname: 'dating_app')

  sql = "delete from moments where id = '#{params["id"]}';"
  conn.exec(sql)
  conn.close

  redirect "/users/#{loggedin_user()['id']}/moments"  

end

get '/users/moments/:id' do

  conn = PG.connect(dbname: 'dating_app')
  user_id = params["id"]
  users = conn.exec("SELECT * FROM users where id=#{loggedin_user()["id"]};")
  user = users[0]

  sql = "select * from moments where id = #{params['id']}"
  results = conn.exec(sql)
  
  sql2 = "select * from comments where moment_id = #{params['id']};"

  comments = conn.exec(sql2)

  conn.close


  erb(:user_moment, locals: {
    results: results,
    user: user,
    comments: comments
  })
end


post '/comments/moments/:id' do
  params.to_s
  if logged_in?
    conn = PG.connect(dbname: 'dating_app')
    sql = "insert into comments (content, email, moment_id) values ('#{params['content']}', '#{loggedin_user()["email"]}', #{params['id']});"
    result = conn.exec_params(sql)
    conn.close
  end
  redirect '/users/moments/:id'
end






