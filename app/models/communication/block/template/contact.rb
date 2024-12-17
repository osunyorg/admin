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

  def socials
    [
      social_mastodon,
      social_x,
      social_linkedin,
      social_youtube,
      social_vimeo,
      social_peertube,
      social_instagram,
      social_facebook,
      social_tiktok,
      social_github
    ].compact_blank
  end

  def children
    emails + phone_numbers + socials
  end

  def has_emails?
    emails.any?(&:present?)
  end

  def has_phone_numbers?
    phone_numbers.any?(&:present?)
  end

  def has_socials?
    socials.any?(&:present?)
  end
end
