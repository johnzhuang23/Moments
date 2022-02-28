# USER LOG OUT
delete '/login' do
    session[:user_id] = nil
    redirect "/"
end