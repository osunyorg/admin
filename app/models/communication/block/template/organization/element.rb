class Communication::Block::Template::Organization::Element < Communication::Block::Template::Base

  has_component :id, :organization
  has_component :name, :string
  has_component :url, :string
  has_component :logo, :image

  def organization
    id_component.organization
  end

  def organization_id
    id_component.data
  end

  def best_name
    organization ? organization.to_s_in(block.language) : name
  end

  def best_url
    return url unless organization
    organization_l10n = organization.best_localization_for(block.language)
    organization_l10n.url
  end

  def best_logo_blob
    return logo_component.blob unless organization
    organization_l10n = organization.best_localization_for(block.language)
    organization_l10n.logo&.blob
  end

end
