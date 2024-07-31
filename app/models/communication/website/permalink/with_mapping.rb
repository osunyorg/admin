module Communication::Website::Permalink::WithMapping
  extend ActiveSupport::Concern

  included do
    MAPPING = {
      # TODO L10N : Remove after migration
      "Administration::Location" => Communication::Website::Permalink::Location,
      "Communication::Website::Agenda::Event" => Communication::Website::Permalink::Agenda::Event,
      "Communication::Website::Agenda::Category" => Communication::Website::Permalink::Agenda::Category,
      "Communication::Website::Page" => Communication::Website::Permalink::Page,
      "Communication::Website::Portfolio::Project" => Communication::Website::Permalink::Portfolio::Project,
      "Communication::Website::Portfolio::Category" => Communication::Website::Permalink::Portfolio::Category,
      "Communication::Website::Post" => Communication::Website::Permalink::Post,
      "Communication::Website::Post::Category" => Communication::Website::Permalink::Category,
      "Education::Diploma" => Communication::Website::Permalink::Diploma,
      "Education::Program" => Communication::Website::Permalink::Program,
      "Research::Journal::Paper" => Communication::Website::Permalink::Paper,
      "Research::Journal::Volume" => Communication::Website::Permalink::Volume,
      "Research::Publication" => Communication::Website::Permalink::Publication,
      "University::Organization" => Communication::Website::Permalink::Organization,
      "University::Organization::Category" => Communication::Website::Permalink::Organization::Category,
      "University::Person" => Communication::Website::Permalink::Person,
      "University::Person::Category" => Communication::Website::Permalink::Person::Category,
      "University::Person::Administrator" => Communication::Website::Permalink::Administrator,
      "University::Person::Author" => Communication::Website::Permalink::Author,
      "University::Person::Researcher" => Communication::Website::Permalink::Researcher,
      "University::Person::Teacher" => Communication::Website::Permalink::Teacher,
      # END TODO L10N

      # Les lignes commentées nous servent à ne rien oublier pendant la migration.
      # Quand la migration l10n sera terminée, tout sera décommenté.
      # "Administration::Location::Localization" => Communication::Website::Permalink::Location,
      "Communication::Website::Agenda::Event::Localization" => Communication::Website::Permalink::Agenda::Event,
      "Communication::Website::Agenda::Category::Localization" => Communication::Website::Permalink::Agenda::Category,
      "Communication::Website::Page::Localization" => Communication::Website::Permalink::Page,
      # "Communication::Website::Portfolio::Project::Localization" => Communication::Website::Permalink::Portfolio::Project,
      # "Communication::Website::Portfolio::Category::Localization" => Communication::Website::Permalink::Portfolio::Category,
      "Communication::Website::Post::Localization" => Communication::Website::Permalink::Post,
      "Communication::Website::Post::Category::Localization" => Communication::Website::Permalink::Category,
      # "Education::Diploma::Localization" => Communication::Website::Permalink::Diploma,
      # "Education::Program::Localization" => Communication::Website::Permalink::Program,
      # "Research::Journal::Paper::Localization" => Communication::Website::Permalink::Paper,
      # "Research::Journal::Volume::Localization" => Communication::Website::Permalink::Volume,
      # "Research::Publication::Localization" => Communication::Website::Permalink::Publication,
      "University::Organization::Localization" => Communication::Website::Permalink::Organization,
      "University::Organization::Category::Localization" => Communication::Website::Permalink::Organization::Category,
      "University::Person::Localization" => Communication::Website::Permalink::Person,
      "University::Person::Category::Localization" => Communication::Website::Permalink::Person::Category,
      "University::Person::Localization::Administrator" => Communication::Website::Permalink::Administrator,
      "University::Person::Localization::Author" => Communication::Website::Permalink::Author,
      "University::Person::Localization::Researcher" => Communication::Website::Permalink::Researcher,
      "University::Person::Localization::Teacher" => Communication::Website::Permalink::Teacher
    }

    def self.for_object(object, website)
      lookup_key = self.lookup_key_for_object(object)
      permalink_class = MAPPING[lookup_key]
      raise ArgumentError.new("Permalinks do not handle an object of type #{object.class.to_s}") if permalink_class.nil?
      permalink_class.new(website: website, about: object)
    end

    def self.supported_by?(object)
      lookup_key = self.lookup_key_for_object(object)
      MAPPING.keys.include?(lookup_key)
    end

    def self.lookup_key_for_object(object)
      lookup_key = object.class.to_s
      # Special pages are defined as STI classes (e.g. Communication::Website::Page::Home) but permalinks are handled the same way.
      lookup_key = "Communication::Website::Page" if lookup_key.starts_with?("Communication::Website::Page")
      lookup_key
    end

    protected

    def self.required_kinds_in_website(website)
      MAPPING.values.select { |permalink_class|
        permalink_class.required_in_config?(website)
      }
    end
  end
end
