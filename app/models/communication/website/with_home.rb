module Communication::Website::WithHome
  extend ActiveSupport::Concern

  included do
    has_one :home,
            class_name: 'Communication::Website::Home',
            foreign_key: :communication_website_id,
            dependent: :destroy

    after_create :create_home
  end

  protected

  def create_home
    build_home(university_id: university_id).save
  end
end
