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
    @answers = Answer.where(question_id: @question.id)
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
    @courses = Course.all
    @users = User.all
    @course = Course.find(@question.course_id)
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
    @users = User.all
    @new_votes = @question.votes.to_i + params[:votes].to_i
    if @new_votes >= 0
      @question.update(votes: @new_votes)
      respond_to do |format|
      format.js {render :show}
      format.html
     # if @question.update(question_params)
        #format.html { redirect_to course_path(Course.find(@question.course_id))}
        #format.json { render :show, status: :ok, location: @question }
     # else
        #format.html { render :edit }
        #format.json { render json: @question.errors, status: :unprocessable_entity }
     # end
     end
    end
    
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url}
      format.json { head :no_content }
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
