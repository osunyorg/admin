module Communication::Website::Permalink::WithMapping
  extend ActiveSupport::Concern

  included do
    MAPPING = {
      "Communication::Website::Page" => Communication::Website::Permalink::Page,
      "Communication::Website::Post" => Communication::Website::Permalink::Post, # TODO L10N : To remove
      "Communication::Website::Post::Localization" => Communication::Website::Permalink::Post,
      "Communication::Website::Post::Category" => Communication::Website::Permalink::Category, # TODO L10N : To remove
      "Communication::Website::Post::Category::Localization" => Communication::Website::Permalink::Category,
      "Communication::Website::Agenda::Event" => Communication::Website::Permalink::Agenda::Event,
      "Communication::Website::Agenda::Category" => Communication::Website::Permalink::Agenda::Category,
      "Communication::Website::Portfolio::Project" => Communication::Website::Permalink::Portfolio::Project,
      "Communication::Website::Portfolio::Category" => Communication::Website::Permalink::Portfolio::Category,
      "Administration::Location" => Communication::Website::Permalink::Location,
      "Education::Diploma" => Communication::Website::Permalink::Diploma,
      "Education::Program" => Communication::Website::Permalink::Program,
      "Research::Journal::Paper" => Communication::Website::Permalink::Paper,
      "Research::Journal::Volume" => Communication::Website::Permalink::Volume,
      "Research::Publication" => Communication::Website::Permalink::Publication,
      "University::Organization" => Communication::Website::Permalink::Organization, # TODO L10N : To remove
      "University::Organization::Localization" => Communication::Website::Permalink::Organization,
      "University::Organization::Category" => Communication::Website::Permalink::Organization::Category,
      "University::Person" => Communication::Website::Permalink::Person,
      "University::Person::Category" => Communication::Website::Permalink::Person::Category,
      "University::Person::Administrator" => Communication::Website::Permalink::Administrator,
      "University::Person::Author" => Communication::Website::Permalink::Author,
      "University::Person::Researcher" => Communication::Website::Permalink::Researcher,
      "University::Person::Teacher" => Communication::Website::Permalink::Teacher
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
