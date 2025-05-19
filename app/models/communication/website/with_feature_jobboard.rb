module Communication::Website::WithFeatureJobboard
  extend ActiveSupport::Concern

  included do
    has_many    :jobboard_jobs,
                class_name: "Communication::Website::Jobboard::Job",
                foreign_key: :communication_website_id,
                dependent: :destroy
    alias       :jobs :jobboard_jobs

    has_many    :jobboard_categories,
                class_name: 'Communication::Website::Jobboard::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy

    scope :with_feature_jobboard, -> { where(feature_jobboard: true) }
  end

  def feature_jobboard_name(language)
    begin
      special_page(Communication::Website::Page::CommunicationJobboard).best_localization_for(language)
    rescue
      Communication::Website::Jobboard::Job.model_name.human(count: 2)
    end
  end

  def feature_jobboard_dependencies
    []
    # events +
    # exhibitions +
    # agenda_categories +
    # agenda_years +
    # agenda_months
  end
end