full_width = local_assigns.has_key?(:full_width)        ? local_assigns[:full_width] 
                                                        : @about.full_width
toc_offcanvas = local_assigns.has_key?(:toc_offcanvas)  ? local_assigns[:toc_offcanvas] 
                                                        : @about.full_width
toc_present = local_assigns.has_key?(:toc_present)      ? local_assigns[:toc_present]
                                                        : @about.show_toc?
json.design do
  json.full_width full_width
  json.toc do
    json.present toc_present
    json.offcanvas toc_offcanvas
  end
end
