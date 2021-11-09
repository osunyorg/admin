module ActiveStorage::CheckAbilities
  extend ActiveSupport::Concern

  private

  def check_abilities
    render(file: Rails.root.join('public/403.html'), formats: [:html], status: 403, layout: false) and return if current_university.present? && @blob.university_id != current_university.id
  end

  def current_university
    @current_university ||= University.with_host(request.host)
  end
end
