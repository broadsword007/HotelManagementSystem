json.extract! room_category, :id, :name, :description, :rate, :category_pic_path, :created_at, :updated_at
json.url room_category_url(room_category, format: :json)
