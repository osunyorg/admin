class Communication::Website::Page::LegalTerm < Communication::Website::Page

  def design_options_block_template_kind
    nil
  end

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
