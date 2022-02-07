# == Schema Information
#
# Table name: communication_website_structures
#
#  id                              :uuid             not null, primary key
#  administrators_description      :text             default("Liste des membres de l'équipe administrative")
#  administrators_path             :string           default("equipe-administrative")
#  administrators_title            :string           default("Équipe administrative")
#  authors_description             :text             default("Liste des membres de l'équipe éditoriale")
#  authors_path                    :string           default("equipe-editoriale")
#  authors_title                   :string           default("Équipe éditoriale")
#  communication_posts_description :text             default("Liste des actualités")
#  communication_posts_path        :string           default("actualites")
#  communication_posts_title       :string           default("Actualités")
#  education_programs_description  :text             default("Liste des formations proposées")
#  education_programs_path         :string           default("offre-de-formation")
#  education_programs_title        :string           default("L'offre de formation")
#  home_title                      :string           default("Accueil")
#  persons_description             :text             default("Liste des membres de l'équipe")
#  persons_path                    :string           default("equipe")
#  persons_title                   :string           default("Équipe")
#  research_articles_description   :text             default("Liste des articles")
#  research_articles_path          :string           default("articles")
#  research_articles_title         :string           default("Articles")
#  research_volumes_description    :text             default("Liste des volumes")
#  research_volumes_path           :string           default("volumes")
#  research_volumes_title          :string           default("Volumes")
#  researchers_description         :text             default("Liste des membres de l'équipe de recherche")
#  researchers_path                :string           default("equipe-de-recherche")
#  researchers_title               :string           default("Équipe de recherche")
#  teachers_description            :text             default("Liste des membres de l'équipe pédagogique")
#  teachers_path                   :string           default("equipe-pedagogique")
#  teachers_title                  :string           default("Équipe pédagogique")
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  communication_website_id        :uuid             not null
#  university_id                   :uuid             not null
#
# Indexes
#
#  idx_comm_website_structures_on_communication_website_id  (communication_website_id)
#  index_communication_website_structures_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website::Structure < ApplicationRecord
  include WithGit

  belongs_to :university
  belongs_to :website, foreign_key: :communication_website_id

  validates :home_title,
            :administrators_title, :administrators_path,
            :authors_title, :authors_path,
            :communication_posts_title, :communication_posts_path,
            :education_programs_title, :education_programs_path,
            :persons_title, :persons_path,
            :research_articles_title, :research_articles_path,
            :research_volumes_title, :research_volumes_path,
            :researchers_title, :researchers_path,
            :teachers_title, :teachers_path,
            presence: true

  def to_s
    website.to_s
  end

  # def git_path(website)
  #   'content/_index.html'
  # end


end
