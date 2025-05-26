class Communication::Website::Page::Sitemap < Communication::Website::Page

  def editable_width?
    false
  end

  def full_width
    false
  end

  def show_toc?
    true
  end

  def is_listed_among_children?
    false
  end
  
  def static_layout
    'sitemap'
  end

  def default_menu_identifier
    'legal'
  end

end
