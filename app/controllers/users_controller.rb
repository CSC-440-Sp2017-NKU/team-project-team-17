require 'csv'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :require_admin_registrar, except: [:show_me]
  skip_before_filter :verify_authenticity_token, only: [:new]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end
  
  # GET /users/me
  def show_me
    @user = @current_user
    @user_questions = Question.select("questions.*, SUM(votes.score) score").joins("LEFT OUTER JOIN votes on votes.question_id = questions.id").where(user_id: @current_user.id).group("questions.id")
    @user_answers = Answer.select("answers.*, SUM(votes.score) score").joins("LEFT OUTER JOIN votes on votes.answer_id = answers.id").where(user_id: @current_user.id).group("answers.id")
    @user_score = 0
    @user_questions.each { |q| @user_score+=q.score.to_i }
    @user_answers.each { |a| @user_score+=a.score.to_i }
  end

  # GET /users/new
  def new
    @user = User.new
    @courses = Course.all
  end

  # GET /users/1/edit
  def edit
    @courses = Course.all
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new()
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.is_admin = params[:user][:is_admin]
    @user.is_registrar = params[:user][:is_registrar]
    @courses = Course.where(:id => params[:user][:course_ids])
    @user.courses << @courses
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.is_admin = params[:user][:is_admin]
    @user.is_registrar = params[:user][:is_registrar]
    @courses = Course.where(:id => params[:user][:course_ids])
    @user.courses.destroy_all
    @user.courses << @courses
    respond_to do |format|
      if @user.save()
        format.html { redirect_to users_path}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def import
    User.import(params[:file])
    redirect_to users_url
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :course_id, :is_admin, :is_registrar)
    end
end
