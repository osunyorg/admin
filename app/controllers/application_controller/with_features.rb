module ApplicationController::WithFeatures
  extend ActiveSupport::Concern

  included do

    def feature_education?
      current_university.is_really_a_university? &&
      can?(:read, Education::Program)
    end
    helper_method :feature_education?

    def feature_research?
      current_university.is_really_a_university? && (
        can?(:read, Research::Journal) ||
        can?(:read, Research::Publication) ||
        can?(:read, Research::Laboratory)
      )
    end
    helper_method :feature_research?

    def feature_communication?
      can?(:read, Communication::Website)
    end
    helper_method :feature_communication?

    def feature_administration?
      current_university.is_really_a_university? &&
        can?(:read, Administration::Qualiopi) ||
        can?(:read, Administration::Location) ||
        can?(:read, University::Person::Alumnus)
    end
    helper_method :feature_administration?

    def feature_directory?
      can?(:read, University::Person) ||
      can?(:read, University::Organization) ||
      can?(:read, User)
    end
    helper_method :feature_directory?

  end

end
