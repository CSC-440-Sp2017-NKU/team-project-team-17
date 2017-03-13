json.array!(@courses) do |course|
  json.extract! course, :id, :name, :numQuestions, :description, :professor
  json.url course_url(course, format: :json)
end
