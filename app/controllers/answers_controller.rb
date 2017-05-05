class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
    @user = User.find(@answer.user_id)
  end

  # GET /answers/new
  def new
    @question_id = params[:question_id]
    @question = Question.find(@question_id)
    @answer = Answer.new
    @users = User.all
  end

  # GET /answers/1/edit
  def edit
    #make sure we only let admins edit answers, or the current user edit their own answers
    if (@current_user.id == @answer.user_id) || user_is_admin?
      @users = User.all
      @question_id = @answer.question_id
      @question = Question.find(@question_id)
    else
      redirect_to courses_url
    end
  end

  # POST /answers
  # POST /answers.json
  def create
    @users = User.all
    @answer = Answer.new(answer_params)

    respond_to do |format|
      if @answer.save
        format.html { redirect_to question_path(Question.find(@answer.question_id))}
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
      respond_to do |format|
        format.js {
          #if a request comes in as JS, we know its an AJAX call, so treat it as such. 
          #the only AJAX call that is made to update is a vote, so we update the score
          new_vote = Vote.new(user_id: params[:current_user].to_i, question_id: nil, answer_id: @answer.id, score: params[:votes].to_i)
          new_vote.save
          @score = Vote.where(answer_id: @answer.id).sum(:score)
          render :show
        }
        format.html {
          #an html request coming in to update is going to be a regular update from the form, so just update the answer record
          if (@current_user.id == @answer.user_id) || user_is_admin?
            @answer.update(answer_params)
            redirect_to question_path(Question.find(@answer.question_id))
          else
            redirect_to courses_url
          end
        }
      end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    #make sure we only let admins delete answers, or the current user delete their own answers
    if (@current_user.id == @answer.user_id) || user_is_admin?
      @question = Question.find(@answer.question_id)
      @answer.destroy
      respond_to do |format|
        format.html { redirect_to question_path(@question)}
        format.json { head :no_content }
      end
    else
      redirect_to courses_url
    end
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:question_id, :user_id, :content, :votes, :current_user)
    end
end
