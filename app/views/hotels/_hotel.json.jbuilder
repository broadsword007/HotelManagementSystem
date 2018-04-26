json.extract! hotel, :id, :name, :slogan, :location, :hotel_pic_path, :description, :created_at, :updated_at
json.url hotel_url(hotel, format: :json)
