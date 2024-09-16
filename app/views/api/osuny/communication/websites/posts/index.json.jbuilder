json.array! @posts.each do |post|
  json.id post.id
  json.title post.title
end
