json.extract! @page,
              :id,
              :title,
              :slug,
              :breadcrumb_title,
              :full_width,
              :header_text,
              :bodyclass,
              :meta_description,
              :published,
              :type,
              :position

json.path admin_communication_website_page_path(@page, format: :json)

json.featured_image do
  json.alt @l10n.featured_image_alt
  json.credit @l10n.featured_image_credit
  json.media @l10n.featured_image.blob.id
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
