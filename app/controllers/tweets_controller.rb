class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[ show edit update destroy retweet ]

  # GET /tweets or /tweets.json
  def index
    @tweets = @q.result.order(created_at: :desc).page(params[:page])
  end

  # GET /tweets/1 or /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets or /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    # @tweet.content = @tweet.hcontent

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to root_path, notice: "Tweet was successfully created." }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1 or /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to root_path, notice: "Tweet was successfully updated." }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1 or /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Tweet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # RETWEET
  def retweet
    @tweet = current_user.tweets.create(rt_tweet_id: @tweet.id)
    if @tweet.save
      redirect_to root_path
    else
      redirect_to root_path, alert: "No se puede retweetear"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content, :tweet_id, :user_id)
    end
end
