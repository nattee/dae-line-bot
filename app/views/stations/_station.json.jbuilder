json.extract! station, :id, :course_id, :code, :shortname, :name, :distance, :cutoff, :created_at, :updated_at
json.url station_url(station, format: :json)
