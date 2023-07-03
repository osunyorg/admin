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
  json.alt @page.featured_image_alt
  json.credit @page.featured_image_credit
  json.media @page.featured_image.blob.id
end if @page.featured_image.attached?

language = @page.language
json.language do
  json.extract! language, :id, :name, :iso_code, :summernote_locale
  json.label language_name(language.iso_code)
end

original = @page.original
json.original do
  json.extract! original, :id, :title
  json.path admin_communication_website_page_path(original, format: :json)
end if original

parent = @page.parent
json.parent do
  json.extract! parent, :id, :title
  json.path admin_communication_website_page_path(parent, format: :json)
end if parent
