require 'sinatra/reloader' 
require 'pg' 


get '/users/:id/posts' do

  redirect '/login' unless logged_in?

    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
  
    user_id = params["id"]
    users = conn.exec("SELECT * FROM users where id=#{user_id};")
    user = users[0]
  
    sql = "select * from users full join posts on users.id = posts.user_id where users.id= '#{params["id"]}' order by posts.id DESC;"
    userposts = conn.exec(sql)
    conn.close
  
    erb( :user_posts_display, locals: {
      userposts: userposts,
      user: user
    })
  end

  # EDIT
get '/users/:id/edit' do

  redirect '/login' unless logged_in?
    user = db_query("select * from users where id = $1", [params['id']])[0]
    erb(:edit_user,locals: {
      user: user
      })
  end
    
  # UPDATE
  put '/users/:id' do
    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})

    sql = "UPDATE users SET user_name = '#{params['name']}', user_avatar_url = '#{params['user_avatar_url']}' WHERE id = '#{params['id']}';"
    conn.exec(sql)

    conn.close
  
    redirect "/users/#{params['id']}"
    
  end


  get '/users/:id' do
    user_id = params["id"]
    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
    users = conn.exec("SELECT * FROM users where id=#{user_id};")
    user = users[0]
    conn.close
  
    erb(:user_detail, locals: {
    user: user
    })
  end

