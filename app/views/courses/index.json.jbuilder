json.array!(@courses) do |course|
  json.extract! course, :id, :name, :description, :professor
  json.url course_url(course, format: :json)
end
