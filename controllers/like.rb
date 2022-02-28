require 'pg'
enable :sessions 

def like_post(user_id, post_id)
    post_sql = "update posts set likes_count = likes_count +1 where id = $1;" 
    db_query(post_sql, [post_id])
    like_sql = "insert into likes (user_id, post_id) values ($1, $2);"
    db_query(like_sql, [user_id, post_id])
end

def unlike_post(user_id, post_id)
    post_sql = "update posts set likes_count = likes_count -1 where id = $1;"
    db_query(post_sql,[post_id])
    unlike_sql = "delete from likes where user_id = $1 and post_id = $2"
    db_query(unlike_sql, [user_id, post_id])
end

def liked?(user_id, post_id)
    sql = "select * from likes where user_id = $1 and post_id = $2;"
    result = db_query(sql, [user_id, post_id])
    if result.count > 0 
        return true
    else
        return false
    end
end

def not_liked?(user_id, post_id) 
    sql = "select * from likes where user_id = $1 and post_id = $2;"
    result = db_query(sql, [user_id, post_id])
    if result.count > 0 
        return false
    else
        return true
    end
end


post '/like' do
    redirect '/login' unless logged_in?
    redirect "/users/posts/#{params['post_id']}" unless loggedin_user()['id'] == params['user_id']
  
    like_post(params['user_id'], params['post_id'])
    redirect "/users/posts/#{params['post_id']}"
  end
  
  post '/unlike' do
    redirect '/login' unless logged_in?
    redirect "/users/posts/#{params['post_id']}" unless loggedin_user()['id'] == params['user_id']
  
    unlike_post(params['user_id'], params['post_id'])
    redirect "/users/posts/#{params['post_id']}"
  end
