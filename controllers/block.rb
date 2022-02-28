require 'sinatra/reloader' 
require 'pg' 
enable :sessions

post "/users/:id/block" do
    redirect '/login' unless logged_in?
    # for leayout part
    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'moments_ruby'})
    users = conn.exec("SELECT * FROM users where id=#{loggedin_user()["id"]};")
    user = users[0]


    sql2 = "select * from posts where id = #{params['id']};"
    post = conn.exec(sql2)


    sql="insert into blacklist (user_id, user_id_blocked) values ('#{loggedin_user()['id']}', '#{post[0]['user_id']}');"

    result_block=conn.exec_params(sql)
    conn.close

end
