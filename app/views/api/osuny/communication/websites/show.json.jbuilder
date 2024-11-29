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
json.localizations @website.localizations do |l10n|
  json.extract! l10n, :id, :name
  json.language l10n.language.iso_code
  json.extract! l10n,
                :published, :published_at,
                :social_email, :social_facebook, :social_github, :social_instagram,
                :social_linkedin, :social_mastodon, :social_peertube, :social_tiktok,
                :social_vimeo, :social_x, :social_youtube, :created_at, :updated_at
end
json.created_at @website.created_at
json.updated_at @website.updated_at