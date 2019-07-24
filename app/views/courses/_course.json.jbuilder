json.extract! course, :id, :race_id, :title, :distance, :start, :stop, :created_at, :updated_at
json.url course_url(course, format: :json)
