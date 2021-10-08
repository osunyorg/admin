module ActiveStorage::CheckAbilities
  extend ActiveSupport::Concern

  private

  def check_abilities
    university = University.with_host(request.host)
    render(file: Rails.root.join('public/403.html'), formats: [:html], status: 403, layout: false) and return if university.present? && @blob.university_id != university.id
  end
end
