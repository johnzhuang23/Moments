require 'sinatra/reloader' 

require 'pg' 
require 'bcrypt' 

# USER SIGN UP
get '/signup' do
    erb(:signup)
end
  
post '/signup' do
    params.to_s
  
    password = params["password"]
    email = params["email"]
    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
    password_digest = BCrypt::Password.create(password)
    sql = "insert into users (email, password_digest) values ('#{email}', '#{password_digest}');"
    conn.exec(sql)
    
    session[:user_id]=conn.exec("select * from users where email = '#{email}';")[0]['id']
    conn.close
    redirect "/users/#{session[:user_id]}/edit"

end