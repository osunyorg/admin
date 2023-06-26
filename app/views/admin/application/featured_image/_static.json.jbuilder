best_featured_image = @about.best_featured_image
json.image do
  json.id best_featured_image.blob.id
  json.alt @about.best_featured_image_alt
  json.credit @about.best_featured_image_credit
end if best_featured_image&.attached?
