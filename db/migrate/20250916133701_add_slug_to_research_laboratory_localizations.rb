class AddSlugToResearchLaboratoryLocalizations < ActiveRecord::Migration[8.0]
  def change
    add_column :research_laboratory_localizations, :slug, :string
    Research::Laboratory::Localization.reset_column_information
    Research::Laboratory::Localization.find_each do |laboratory_l10n|
      laboratory_l10n.update_column :slug, laboratory_l10n.to_s.parameterize
    end
  end
end
