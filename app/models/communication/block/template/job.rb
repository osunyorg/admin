class Communication::Block::Template::Job < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list
  ]
  has_component :mode, :option, options: [
    :all,
    :category,
    :selection
  ]
  has_component :jobs_quantity, :number, default: 3
  has_component :category_id, :job_category
  has_component :description, :rich_text
  has_component :no_job_message, :string

  has_component :option_image,        :boolean, default: true
  has_component :option_subtitle,     :boolean, default: true
  has_component :option_categories,   :boolean, default: false
  has_component :option_date,         :boolean, default: false
  has_component :option_summary,      :boolean, default: true

  def category
    category_id_component.category
  end

  def dependencies
    selected_jobs
  end

  def selected_jobs
    @selected_jobs ||= send "selected_jobs_#{mode}"
  end

  def allowed_for_about?
    website.present? && website.feature_jobboard
  end

  def children
    selected_jobs
  end

  def top_link
    return link_to_category if mode == 'category' && category.present?
    return link_to_special_page if mode == 'all'
    nil
  end

  protected

  def link_to_category
    category_l10n = category.localization_for(block.language)
    permalink_for(category_l10n)
  end

  def link_to_special_page
    special_page_l10n = special_page.localization_for(block.language)
    permalink_for(special_page_l10n)
  end

  def permalink_for(l10n)
    return if l10n.nil?
    hugo = l10n.hugo(website)
    hugo.permalink
  end

  def base_jobs
    block.about&.website
                .jobs
                .published_now_in(block.language)
  end

  def selected_jobs_all
    base_jobs.ordered(block.language)
             .limit(jobs_quantity)
  end

  def selected_jobs_category
    return [] if category.nil?
    category_ids = [category.id, category.descendants.map(&:id)].flatten

    base_jobs.for_category(category_ids)
             .ordered(block.language)
             .limit(jobs_quantity)
  end

  def selected_jobs_selection
    elements.map { |element|
      job(element.id)
    }.compact
  end

  def job(id)
    return if id.blank?
    base_jobs.find_by(id: id)
  end

  def special_page
    @special_page ||= website.special_page(Communication::Website::Page::CommunicationJobboard)
  end
end
