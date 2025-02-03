taxonomies = categories.taxonomies
free_categories = categories.free

def show_children(json, category)
  children = category.children.ordered(current_language)
  json.categories children.each do |child|
    show_category(json, child)
  end if children.any?
end

def show_category(json, category)
  json.id category.id
  json.name category.to_s_in(current_language)
  show_children(json, category)
end

json.taxonomies do
  taxonomies.each do |taxonomy|
    json.child! do
      json.name taxonomy.to_s_in(current_language)
      show_children(json, taxonomy)
    end
  end
  json.child! do
    json.name t('category.title')
    json.categories free_categories do |category|
      show_category(json, category)
    end
  end
end