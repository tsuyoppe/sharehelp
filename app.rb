require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'sinatra/json'
require './image_uploader.rb'

require './models'
enable :sessions

get '/' do
    @categories = Category.all
    @contents = Contribution.order('id desc').all
    @content = Contribution.find_by({id: params[:id]})
    erb :index
end

#getサインイン用
get '/signin' do
    @categories = Category.all
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
    @categories = Category.all
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
    @categories = Category.all
    Contribution.create({
        name: params[:user_name],
        body: params[:body],
        img: "",
        good: 0,
        bad: 0,
        category_id: params[:category],
        user_id: session[:user]
    })
    
    if params[:file]
        image_upload(params[:file])
    end
    
    redirect '/'
end

#特定の投稿を削除するときの処理
get '/delete/:id' do
    @categories = Category.all
    @content = Contribution.find_by({id: params[:id]})
    if @content.user_id == session[:user]
        unless @content.nil?
        @content.destroy
        redirect '/'
        end
    end
    redirect '/'
end

# 特定の投稿を編集するときの処理
get '/edit/:id' do
    @categories = Category.all
    @content = Contribution.find_by({id: params[:id]})
    if @content.nil?
        redirect '/'
    end
    if @content.user_id == session[:user]
    erb :edit
    else
        redirect '/'
    end
end

# 特定の投稿を更新するときの処理
post '/edit/:id' do
    @content = Contribution.find_by({id: params[:id]})
    if @content.nil?
        redirect '/'
    end
    @content.update({
        name:        params[:name],
        body:        params[:body],
        category_id: params[:category],
    })
    @content.save

    redirect '/'
end

post '/renew/:id' do
    @content = Contribution.find(params[:id])
    @content.update({
        name: params[:user_name],
        body: params[:body]
    })
    redirect  '/'
end

post '/good/:id' do
    @content = Contribution.find(params[:id])
    good = @content.good
    @content.update({
        good: good + 1
    })
    redirect '/'
end

post '/bad/:id' do
    @content = Contribution.find(params[:id])
    bad = @content.bad
    @content.update({
        bad: bad + 1
    })
    redirect '/'
end

# メモをカテゴリ分類して表示するときの処理
get '/categories/:id' do
    @categories = Category.all
    @category = @categories.find_by({id: params[:id]})
    if @category.nil?
        @contents = []
    else
        @contents = @category.contributions
    end
    
    erb :index
end