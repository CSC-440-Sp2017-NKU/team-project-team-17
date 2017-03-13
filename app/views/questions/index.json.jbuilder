json.array!(@questions) do |question|
  json.extract! question, :id, :course_id, :title, :user_id, :content, :num_answers
  json.url question_url(question, format: :json)
end
