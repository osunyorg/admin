class MigrateExperiences < ActiveRecord::Migration[7.1]
  def change
    University::Person::Experience.find_each do |experience|
      # En théorie, il faut : 
      # 1. vérifier que l'expérience originale existe,
      # 2. sinon la créer
      # 3. puis supprimer l'expérience
      # En pratique, les expériences concernent uniquement MMI et IJBA, qui sont monolingues, donc on saute au 3.
      organization = experience.organization
      person = experience.person
      experience_is_original = organization.original_id.blank? && person.original_id.blank?
      experience.destroy unless experience_is_original
    end
  end
end
