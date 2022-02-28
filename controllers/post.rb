require 'sinatra/reloader' 
require 'pg' 
enable :sessions

get '/posts/new' do
    redirect '/login' unless logged_in?

    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
      sql = "select * from users where id = #{session[:user_id]};"
      user = conn.exec(sql)[0]
      conn.close
  
    erb(:new_post, locals: {
      user: user
    })
end
  
post '/posts' do
    params.to_s
    if logged_in?
      conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
      sql = "insert into posts (image_url, content, user_id, likes_count) values ('#{params['image_url']}', '#{params['user_text']}', '#{loggedin_user()["id"]}', '0');"
      result = conn.exec_params(sql)
      conn.close
    end
    redirect '/'
end


get '/myposts' do

  redirect '/login' unless logged_in?

    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
  
    user_id = params["id"]
    users = conn.exec("SELECT * FROM users where id=#{loggedin_user()["id"]};")
    user = users[0]
  
    sql = "select * from users full join posts on users.id = posts.user_id where users.id= '#{loggedin_user()["id"]}' order by posts.id DESC;"
    userposts = conn.exec(sql)
    conn.close
  
    erb( :user_posts_edit, locals: {
      userposts: userposts,
      user: user
    })
  
  end

#   Edit post
get '/posts/:id/edit' do

    redirect '/login' unless logged_in?



    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})

    users = conn.exec("SELECT * FROM users where id=#{loggedin_user()["id"]};")

    user = users[0]
  

      sql = "select * from posts where id = #{params["id"]};"
      post = conn.exec(sql)[0]
      conn.close

    erb(:edit_post, locals: {
      post: post,
      user: user
    })

end

put '/posts/:id/edit' do

    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
  
    sql = "update posts set content = '#{params["content"]}', image_url= '#{params["image_url"]}' where id = '#{params["id"]}';"
    conn.exec(sql)
    conn.close
  
    redirect "/myposts"  
    # redirect "/users/#{loggedin_user()['id']}/posts"  
  end


  # DELETE post
delete '/posts/:id/delete' do

    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
  
    sql = "delete from posts where id = '#{params["id"]}';"
    conn.exec(sql)
    conn.close
    # redirect "/users/#{loggedin_user()['id']}/posts"  
    redirect "/myposts"  
  
  end
