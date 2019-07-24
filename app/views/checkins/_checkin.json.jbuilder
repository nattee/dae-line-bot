json.extract! checkin, :id, :run_id, :distance, :time, :type, :location, :remark, :created_at, :updated_at
json.url checkin_url(checkin, format: :json)
