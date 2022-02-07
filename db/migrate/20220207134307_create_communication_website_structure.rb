class CreateCommunicationWebsiteStructure < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_structures, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website,
          null: false,
          foreign_key: { to_table: :communication_websites },
          type: :uuid,
          index: { name: 'idx_comm_website_structures_on_communication_website_id' }


      t.string "persons_title", default: "Équipe"
      t.text "persons_description", default: "Liste des membres de l'équipe"
      t.string "persons_path", default: "equipe"

      t.string "authors_title", default: "Équipe éditoriale"
      t.text "authors_description", default: "Liste des membres de l'équipe éditoriale"
      t.string "authors_path", default: "equipe-editoriale"

      t.string "researchers_title", default: "Équipe de recherche"
      t.text "researchers_description", default: "Liste des membres de l'équipe de recherche"
      t.string "researchers_path", default: "equipe-de-recherche"

      t.string "administrators_title", default: "Équipe administrative"
      t.text "administrators_description", default: "Liste des membres de l'équipe administrative"
      t.string "administrators_path", default: "equipe-administrative"

      t.string "teachers_title", default: "Équipe pédagogique"
      t.text "teachers_description", default: "Liste des membres de l'équipe pédagogique"
      t.string "teachers_path", default: "equipe-pedagogique"

      t.string "communication_posts_title", default: "Actualités"
      t.text "communication_posts_description", default: "Liste des actualités"
      t.string "communication_posts_path", default: "actualites"

      t.string "education_programs_title", default: "L'offre de formation"
      t.text "education_programs_description", default: "Liste des formations proposées"
      t.string "education_programs_path", default: "offre-de-formation"

      t.string "research_volumes_title", default: "Volumes"
      t.text "research_volumes_description", default: "Liste des volumes"
      t.string "research_volumes_path", default: "volumes"

      t.string "research_articles_title", default: "Articles"
      t.text "research_articles_description", default: "Liste des articles"
      t.string "research_articles_path", default: "articles"

      t.timestamps
    end
  end
end
