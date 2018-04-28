json.extract! booking, :id, :user_id, :room_id, :from, :to, :hasCheckedOut, :created_at, :updated_at
json.url booking_url(booking, format: :json)
