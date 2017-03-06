require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'sinatra/json'
require './image_uploader.rb'

require './models'
enable :sessions

get '/' do
    @contents = Contribution.order('id desc').all
    erb :index
end

#getサインイン用
get '/signin' do
    erb :sign_in
end

#postサインイン用
post '/signin' do 
    user = User.find_by(mail: params[:mail])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/'
end

#getサインアップ用
get '/signup' do
    erb :sign_up
end

#postサインアップ用
post '/signup' do
    @user = User.create(mail:params[:mail],password:params[:password],
        password_confirmation:params[:password_confirmation])
    if @user.persisted?
        session[:user] = @user.id
    end
    redirect '/'
end

#サインアウト用
get '/signout' do
    session[:user] = nil
    redirect '/'
end


post '/new' do
    Contribution.create({
        name: params[:user_name],
        body: params[:body],
        img: ""
    })
    
    if params[:file]
        image_upload(params[:file])
    end
    
    redirect '/'
end

post '/delete/:id' do
    Contribution.find(params[:id]).destroy
    redirect '/'
end

post '/edit/:id' do
    @content = Contribution.find(params[:id])
    erb :edit
end

post '/renew/:id' do
    @content = Contribution.find(params[:id])
    @content.update({
        name: params[:user_name],
        body: params[:body]
    })
    redirect  '/'
end

