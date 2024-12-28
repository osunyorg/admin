class Communication::Website::Page::LegalTerm < Communication::Website::Page

  DEFAULT_CONTENT = [
    {
      title: 'Direction de publication',
      template_kind: :title
    },
    {
      template_kind: :chapter,
      data: {
        text: '<p>[Prénom Nom]<br>[Adresse postale]<br>[Adresse email]</p>'
      }
    }
  ]

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
