class Communication::Website::Page::PrivacyPolicy < Communication::Website::Page

  def draftable?
    false
  end

  def is_listed_among_children?
    false
  end

  def default_menu_identifier
    'legal'
  end
  
end
