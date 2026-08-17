json.extract! @l10n, :title, :initials, :published

json.featured_image do
  json.thumb url_for(@l10n.featured_blob.variant(resize_to_fill: [140, 140]))
end if @l10n.featured_blob.present?
