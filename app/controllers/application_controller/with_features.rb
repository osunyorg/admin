module ApplicationController::WithFeatures
  extend ActiveSupport::Concern

  included do

    def feature_education?
      current_university.feature_education &&
      can?(:read, Education::Program)
    end
    helper_method :feature_education?
    
    def feature_research?
      current_university.feature_research && (
        can?(:read, Research::Journal) ||
        can?(:read, Research::Hal::Publication) ||
        can?(:read, Research::Laboratory)
      )
    end
    helper_method :feature_research?
    
    def feature_communication?
      current_university.feature_communication &&
      can?(:read, Communication::Website)
    end
    helper_method :feature_communication?

    def feature_administration?
      current_university.feature_administration &&
        can?(:read, Administration::Qualiopi::Criterion)
    end
    helper_method :feature_administration?

  end

end
