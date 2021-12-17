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

    def inherited_accessibility
      accessibility.blank? ? parent&.inherited_accessibility : accessibility
    end

    def inherited_contacts
      contacts.blank? ? parent&.inherited_contacts : contacts
    end

    def inherited_duration
      duration.blank? ? parent&.inherited_duration : duration
    end

    def inherited_evaluation
      evaluation.blank? ? parent&.inherited_evaluation : evaluation
    end

    def inherited_objectives
      objectives.blank? ? parent&.inherited_objectives : objectives
    end

    def inherited_opportunities
      opportunities.blank? ? parent&.inherited_opportunities : opportunities
    end

    def inherited_other
      other.blank? ? parent&.inherited_other : other
    end

    def inherited_pedagogy
      pedagogy.blank? ? parent&.inherited_pedagogy : pedagogy
    end

    def inherited_prerequisites
      prerequisites.blank? ? parent&.inherited_prerequisites : prerequisites
    end

    def inherited_pricing
      pricing.blank? ? parent&.inherited_pricing : pricing
    end

    def inherited_registration
      registration.blank? ? parent&.inherited_registration : registration
    end

  end
end
