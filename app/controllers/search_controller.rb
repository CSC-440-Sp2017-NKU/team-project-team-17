class SearchController < ApplicationController
    def show
        
        @query = params[:query]
        if @query.eql? ""
            redirect_to :back
        else
            @questions = Question.select("questions.*, SUM(votes.score) score").joins("LEFT OUTER JOIN votes on votes.question_id = questions.id").group("questions.id")
            @answers = Answer.all
            @search_results = []
            @questions.each do |q|
                if (q.content.downcase.include? @query.downcase or q.title.downcase.include? @query.downcase)
                    @search_results << q
                end
            end
        end
    end
end
