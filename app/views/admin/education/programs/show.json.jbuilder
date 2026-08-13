json.extract! @l10n, :name, :initials, :published
json.featured_image do
  json.thumb url_for(@l10n.featured_image.variant(resize_to_fill: [140, 140]))
  json.full url_for(@l10n.featured_image)
end if @l10n.featured_image.attached?