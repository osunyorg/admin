json.extract! @l10n, :title, :initials, :published
json.featured_media json.thumb @l10n.featured_media.thumb_url if @l10n.featured_media.present?
