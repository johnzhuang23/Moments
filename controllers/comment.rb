require 'sinatra/reloader' 
require 'pg' 
enable :sessions
require 'pry'

get '/users/posts/:id' do

    redirect '/login' unless logged_in?

    # for leayout part
    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})

    users = conn.exec("SELECT * FROM users where id=#{loggedin_user()["id"]};")

    user = users[0]
  

    # for post and comment
    
    sql = "select * from posts where id = #{params['id']}"
    post = conn.exec(sql)
    
    sql2 = "select * from comments where post_id = #{params['id']};"
    comments = conn.exec(sql2)

    sql3= "select email from users full join posts on posts.user_id = users.id where posts.id=#{params['id']};"
    user_post_email = conn.exec(sql3)[0]

    sql4= "select user_name from users full join posts on posts.user_id = users.id where posts.id=#{params['id']};"
    user_post_username = conn.exec(sql4)[0]

    sql5= "select user_avatar_url from users full join posts on posts.user_id = users.id where posts.id=#{params['id']};"
    user_post_avatar= conn.exec(sql5)[0]

    conn.close
  
    erb(:user_post, locals: {
      post: post,
      user: user,
      comments: comments,
      user_post_email: user_post_email,
      user_post_username: user_post_username,
      user_post_avatar: user_post_avatar
    })
  end
  

  post '/comments/posts/:id' do
    params.to_s
    if logged_in?
      conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
      
      conn.exec_params("insert into comments (content, user_id, email, post_id, user_name) values ('#{params['content']}', '#{loggedin_user()["id"]}', '#{loggedin_user()["email"]}', '#{params['id']}','#{loggedin_user()["user_name"]}');")

      conn.close

    end
    redirect "/users/posts/#{params['id']}"
  end

  require_relative "block.rb"
  require_relative "like.rb"
