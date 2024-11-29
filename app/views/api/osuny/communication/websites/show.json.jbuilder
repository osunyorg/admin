json.id @website.id
json.name @website.to_s_in(current_language)
json.url @website.url
json.deuxfleurs do
  json.hosting @website.deuxfleurs_hosting
  json.identifier @website.deuxfleurs_identifier
end
json.features do
  json.agenda @website.feature_agenda
  json.portfolio @website.feature_portfolio
  json.posts @website.feature_posts
end
json.git do
  json.branch @website.git_branch
  json.endpoint @website.git_endpoint
  json.provider @website.git_provider
  json.repository @website.repository
end
json.showcase do
  json.present @website.in_showcase
  json.highlighted @website.highlighted_in_showcase
  json.tags do
    json.array! @website.showcase_tags, :id, :name, :slug
  end
end
