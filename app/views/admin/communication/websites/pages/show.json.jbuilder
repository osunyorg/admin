json.extract! @page, :id
json.extract! @l10n,
              :title, :slug, :breadcrumb_title,
              :header_text, :meta_description, :published
json.extract! @page,
              :bodyclass, :full_width, :type, :position
json.path admin_communication_website_page_path(@page, format: :json)

json.featured_image do
  json.alt @l10n.featured_image_alt
  json.credit @l10n.featured_image_credit
  json.blob_id @l10n.featured_image.blob_id
end if @l10n.featured_image.attached?

language = @l10n.language
json.language do
  json.extract! language, :id, :name, :iso_code, :summernote_locale
  json.label language_name(language.iso_code)
end

parent = @page.parent
json.parent do
  json.extract! parent, :id
  json.path admin_communication_website_page_path(parent, format: :json)
end if parent
