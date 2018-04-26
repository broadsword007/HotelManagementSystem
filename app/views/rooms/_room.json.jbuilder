json.extract! room, :id, :number, :isAvailable, :description, :category_id, :price, :user_id, :created_at, :updated_at
json.url room_url(room, format: :json)
