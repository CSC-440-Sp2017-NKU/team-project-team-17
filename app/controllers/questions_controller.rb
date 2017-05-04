class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
    @courses = Course.all
    @users = User.all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @course = Course.find(@question.course_id)
    @user = User.find(@question.user_id)
    @answers = Answer.select("answers.*, SUM(votes.score) score").joins("LEFT OUTER JOIN votes on votes.answer_id = answers.id").where(question_id: @question.id).group("answers.id")
  end

  # GET /questions/new
  def new
    @question = Question.new
    @courses = Course.all
    @users = User.all
    @course_id = params[:course_id]
  end

  # GET /questions/1/edit
  def edit
    if (@current_user.id == @question.user_id) || user_is_admin?
      @courses = Course.all
      @users = User.all
      @course = Course.find(@question.course_id)
      @course_id = @course.id
    else
      redirect_to courses_url
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    @courses = Course.all
    @users = User.all
    respond_to do |format|
      if @question.save
        format.html { redirect_to course_path(Course.find(@question.course_id))}
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    
      respond_to do |format|
      format.js {
        new_vote = Vote.new(user_id: params[:current_user].to_i, question_id: @question.id, answer_id: nil, score: params[:votes].to_i)
        new_vote.save
        @score = Vote.where(question_id: @question.id).sum(:score)
        render :show
      }
      format.html {
        if (@current_user.id == @question.user_id) || user_is_admin?
          @question.update(question_params)
          redirect_to course_path(Course.find(@question.course_id))
        else
          redirect_to courses_url
        end
      }
      end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    if (@current_user.id == @question.user_id) || user_is_admin?
      @course = Course.find(@question.course_id)
      Answer.destroy_all(question_id: @question.id)
      @question.destroy
      respond_to do |format|
        format.html { redirect_to course_path(@course)}
        format.json { head :no_content }
      end
    else
      redirect_to courses_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:course_id, :title, :user_id, :content, :votes)
    end
end
