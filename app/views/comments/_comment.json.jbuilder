json.extract! comment, :id, :title, :content, :user_id, :rating, :created_at, :updated_at
json.url comment_url(comment, format: :json)
