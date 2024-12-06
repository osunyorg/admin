json.extract! l10n, :id, :name
json.language l10n.language.iso_code
json.extract! l10n,
              :published, :published_at,
              :social_email, :social_facebook, :social_github, :social_instagram,
              :social_linkedin, :social_mastodon, :social_peertube, :social_tiktok,
              :social_vimeo, :social_x, :social_youtube, :created_at, :updated_at