json.extract! @about,
              :title,
              :breadcrumb_title,
              :position
json.partial! 'admin/application/static/permalink'
json.partial! 'admin/application/static/design'
json.layout @about.static_layout if @about.static_layout
json.has do
  json.administrators @website.has_administrators?
  json.authors @website.has_authors?
  json.researchers @website.has_researchers?
  json.teachers @website.has_teachers?
end if @about.is_a?(Communication::Website::Page::Person)
json.partial! 'admin/application/i18n/static'
json.bodyclass @about.best_bodyclass
json.partial! 'admin/application/featured_image/static'
json.children @about.children
                    .published
                    .ordered
                    .select { |child| child.is_listed_among_children? }
                    .collect(&:path)
json.partial! 'admin/application/meta_description/static'
json.partial! 'admin/application/summary/static'
json.header_text @about.header_text
json.partial! 'admin/communication/blocks/content/static', about: @about
