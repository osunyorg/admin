require "test_helper"

# Pour tester juste ce jeu `rake test TEST=test/models/concerns/sluggable_test.rb`
class SluggableTest < ActiveSupport::TestCase
  def test_slugs
    orga_l10n = University::Organization::Localization.new(
      university: default_university,
      language: french,
      name: "Entreprise"
    )
    orga_l10n.set_slug
    assert_equal "entreprise", orga_l10n.slug, "Simple slug"

    orga_l10n.assign_attributes(slug: nil, name: "noesya")
    orga_l10n.set_slug
    assert_equal "noesya-1", orga_l10n.slug, "Duplicate slug adds “-1”"

    orga_l10n.assign_attributes(slug: nil, name: "Un nom d'entreprise avec caractères spéciaux 123")
    orga_l10n.set_slug
    assert_equal "un-nom-dentreprise-avec-caracteres-speciaux-123", orga_l10n.slug, "Special chars are removed"

    orga_l10n.assign_attributes(slug: nil, name: "L'art de cuisiner les スシ")
    orga_l10n.set_slug
    assert_equal "lart-de-cuisiner-les-sushi", orga_l10n.slug, "Transliterate Kana characters"
  end
end
