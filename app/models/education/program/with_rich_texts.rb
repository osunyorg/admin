module Education::Program::WithRichTexts
  extend ActiveSupport::Concern

  included do
    has_rich_text :accessibility
    has_rich_text :contacts
    has_rich_text :duration
    has_rich_text :evaluation
    has_rich_text :objectives
    has_rich_text :opportunities
    has_rich_text :other
    has_rich_text :pedagogy
    has_rich_text :prerequisites
    has_rich_text :pricing
    has_rich_text :registration

    def best_accessibility
      accessibility.blank? ? parent&.best_accessibility : accessibility
    end

    def best_contacts
      contacts.blank? ? parent&.best_contacts : contacts
    end

    def best_duration
      duration.blank? ? parent&.best_duration : duration
    end

    def best_evaluation
      evaluation.blank? ? parent&.best_evaluation : evaluation
    end

    def best_objectives
      objectives.blank? ? parent&.best_objectives : objectives
    end

    def best_opportunities
      opportunities.blank? ? parent&.best_opportunities : opportunities
    end

    def best_other
      other.blank? ? parent&.best_other : other
    end

    def best_pedagogy
      pedagogy.blank? ? parent&.best_pedagogy : pedagogy
    end

    def best_prerequisites
      prerequisites.blank? ? parent&.best_prerequisites : prerequisites
    end

    def best_pricing
      pricing.blank? ? parent&.best_pricing : pricing
    end

    def best_registration
      registration.blank? ? parent&.best_registration : registration
    end

  end
end
