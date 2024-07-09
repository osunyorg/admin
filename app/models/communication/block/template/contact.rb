class Communication::Block::Template::Contact < Communication::Block::Template::Base

  has_component :description, :rich_text
  has_component :name, :string
  has_component :address, :string
  has_component :information, :rich_text
  has_component :zipcode, :string
  has_component :city, :string
  has_component :country, :string
  has_component :url, :string
  has_component :phone_numbers, :array
  has_component :emails, :array
  
  has_component :social_mastodon, :string
  has_component :social_x, :string
  has_component :social_linkedin, :string
  has_component :social_youtube, :string
  has_component :social_vimeo, :string
  has_component :social_peertube, :string
  has_component :social_instagram, :string
  has_component :social_facebook, :string
  has_component :social_tiktok, :string
  has_component :social_github, :string

  has_elements

end
