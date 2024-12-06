json.extract! post, :id, :migration_identifier, :full_width
json.localizations  post.localizations,
                    partial: "api/osuny/communication/websites/posts/localization",
                    as: :l10n
json.extract! post, :created_at, :updated_at
