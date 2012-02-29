class PostsController < ApplicationController
  load_and_authorize_resource :except => [:overview, :show, :feed]

  # GET /posts
  # GET /posts.json
  def index
    authorize! :manage, Post
    
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end
  
  def overview
    authorize! :read, Post
    
    @posts = Post.all(sort: [[ :created_at, :desc ], [ :reads, :desc ]])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :partial => 'sitemap' }
      format.json { render json: @posts }
    end
  end

  def feed
    authorize! :read, Post

    @posts = Post.all(sort: [[ :created_at, :desc ], [ :reads, :desc ]])
    render layout: false
    response.headers['Content-Type'] = 'application/xml; charset=utf8'
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    authorize! :read, Post
    
    @post = Post.find_by_slug(params[:slug], params[:year], params[:month])
    @post.read_up

    @recents = Post.all(sort: [[ :created_at, :desc ], [ :reads, :desc ]], limit: 10)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    2.times{ @post.images.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    2.times{ @post.images.build }
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to root_path, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update  
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to "/read/#{@post.slug}", notice: 'Post was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy    
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end
end
