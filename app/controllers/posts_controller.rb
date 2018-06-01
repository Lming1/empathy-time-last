require 'simple_calendar'
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_user, only: [:edit, :update, :destroy]
  def check_user
       # 유저 전체 데이터가 현재 로그인 되어있는 유저와 다르면 root_path로 돌려보내라
    redirect_to root_path, notice: '권한이없습니다' and return unless @post.user == current_user
  end
  
  def data
    events = Event.all
    render :json => events.map {|event| {
            :id => event.id,
            :start_date => event.start_date.to_formatted_s(:db),
            :end_date => event.end_date.to_formatted_s(:db),
            :text => event.text
        }}
  end
  
  #db_action
  def db_action
    mode = params["!nativeeditor_status"]
    id = params["id"]
    start_date = params["start_date"]
    end_date = params["end_date"]
    text = params["text"]

    case mode
      when "inserted"
        event = Event.create :start_date => start_date, :end_date => end_date, :text => text
        tid = event.id

      when "deleted"
        Event.find(id).destroy
        tid = id

      when "updated"
        event = Event.find(id)
        event.start_date = start_date
        event.end_date = end_date
        event.text = text
        event.save
        tid = id
      end

      render :json => {
                  :type => mode,
                  :sid => id,
                  :tid => tid,
              }
  end
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    # @post = Post.new(post_params)
    # 현 유저의 포스트를 새로 만든다. 
    @post = current_user.posts.new(post_params)

    @post.user_id = current_user.id
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :interval, :starttime, :fintime, :startday, :days)
    end
    
    
    
  
end
