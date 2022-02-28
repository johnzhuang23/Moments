require 'sinatra/reloader' if development?

require 'pg' 
require 'bcrypt' 

# USER LOG IN
get '/login' do
    erb(:login)
  end
  
post '/login' do
    params.to_s
    username = params["username"]
    password = params["password"]
    email = params["email"]
    
    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
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