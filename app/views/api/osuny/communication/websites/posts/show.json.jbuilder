json.extract! @post, :id, :title, :published, :published_at, :pinned, :featured_image_alt, :featured_image_credit, :meta_description, :slug, :summary, :migration_identifier, :created_at, :updated_at
json.migration do
  json.identifier @post.migration_identifier
end if @post.migration_identifier
json.author do 
  json.id @post.author.id
  json.name @post.author.to_s
end if @post.author.present?
