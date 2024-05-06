class AddVisibilityAttributesToUniversityPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :university_people, :address_visibility, :integer, default: 0
    add_column :university_people, :linkedin_visibility, :integer, default: 0
    add_column :university_people, :twitter_visibility, :integer, default: 0
    add_column :university_people, :mastodon_visibility, :integer, default: 0
    add_column :university_people, :phone_mobile_visibility, :integer, default: 0
    add_column :university_people, :phone_professional_visibility, :integer, default: 0
    add_column :university_people, :phone_personal_visibility, :integer, default: 0
    add_column :university_people, :email_visibility, :integer, default: 0

    University::Person.reset_column_information
    # L'existant passe en public pour garder la cohérence (pour les prochains, sera privé par défaut)
    University::Person.update_all(
      address_visibility: :public,
      linkedin_visibility: :public,
      twitter_visibility: :public,
      mastodon_visibility: :public,
      phone_mobile_visibility: :public,
      phone_professional_visibility: :public,
      phone_personal_visibility: :public,
      email_visibility: :public
    )
    # Pour les alumni existants, on passe en restreint pour se limiter aux extranets
    University::Person.where(is_alumnus: true).update_all(
      address_visibility: :restricted,
      linkedin_visibility: :restricted,
      twitter_visibility: :restricted,
      mastodon_visibility: :restricted,
      phone_mobile_visibility: :restricted,
      phone_professional_visibility: :restricted,
      phone_personal_visibility: :restricted,
      email_visibility: :restricted
    )
  end
end
