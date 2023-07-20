module ApplicationController::WithFeatures
  extend ActiveSupport::Concern

  included do

    def feature_education?
      current_university.is_really_a_university &&
      can?(:read, Education::Program)
    end
    helper_method :feature_education?
    
    def feature_research?
      current_university.is_really_a_university && (
        can?(:read, Research::Journal) ||
        can?(:read, Research::Hal::Publication) ||
        can?(:read, Research::Laboratory)
      )
    end
    helper_method :feature_research?
    
    def feature_communication?
      can?(:read, Communication::Website)
    end
    helper_method :feature_communication?

    def feature_administration?
      current_university.is_really_a_university &&
        can?(:read, Administration::Qualiopi::Criterion)
    end
    helper_method :feature_administration?
    
    def feature_settings?
      can?(:read, University::Person) || 
      can?(:read, University::Organization) || 
      can?(:read, User)
    end
    helper_method :feature_settings?

  end

end
