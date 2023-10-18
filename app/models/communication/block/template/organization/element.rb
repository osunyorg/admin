class Communication::Block::Template::Organization::Element < Communication::Block::Template::Base

  has_component :id, :organization
  has_component :name, :string
  has_component :url, :string
  has_component :logo, :image

  def organization
    id_component.organization
  end

  def best_name
    organization ? organization.name : name
  end

  def best_url
    organization ? organization.url : url
  end

  def best_logo_blob
    organization ? organization.logo.blob : logo_component.blob
  end

end
