module Communication::Website::WithAbouts
  extend ActiveSupport::Concern

  included do
    belongs_to  :about,
                polymorphic: true,
                optional: true

    has_many    :pages,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :menus,
                class_name: 'Communication::Website::Menu',
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :posts,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :authors, -> { distinct }, through: :posts

    has_many    :categories,
                class_name: 'Communication::Website::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy

    def self.about_types
      [nil, Education::School.name, Research::Journal.name]
    end

    after_save_commit :set_programs_categories!, if: -> (website) { website.about_school? }
  end

  def about_school?
    about_type == 'Education::School'
  end

  def about_journal?
    about_type == 'Research::Journal'
  end

  def programs
    about_school? ? about.programs : Education::Program.none
  end

  def research_volumes
    about_journal? ? about.volumes : Research::Journal::Volume.none
  end

  def research_articles
    about_journal? ? about.articles : Research::Journal::Article.none
  end

  def people
    @people ||= begin
      people = authors + authors.compact.map(&:author)
      if about_school?
        people += programs.collect(&:university_people_through_teachers).flatten
        people += programs.collect(&:university_people_through_teachers).flatten.map(&:teacher)
        people += about.university_people_through_administrators
        people += about.university_people_through_administrators.map(&:administrator)
      elsif about_journal?
        people += research_articles.collect(&:researchers).flatten
        people += research_articles.collect(&:researchers).flatten.map(&:researcher)
      end
      people.uniq.compact
    end
  end

  def set_programs_categories!
    programs_root_category = categories.where(is_programs_root: true).first_or_create(
      name: 'Offre de formation',
      slug: 'offre-de-formation',
      is_programs_root: true,
      university_id: university.id
    )
    set_programs_categories_at_level! programs_root_category, about.programs.root.ordered
  end

  protected

  def set_programs_categories_at_level!(parent_category, programs)
    programs.map.with_index do |program, index|
      category = categories.where(program_id: program.id).first_or_initialize(
        name: program.name,
        slug: program.name.parameterize,
        university_id: university.id
      )
      category.parent = parent_category
      category.position = index + 1
      category.save
      children = about.programs.where(parent_id: program.id).ordered
      set_programs_categories_at_level! category, children
    end
  end
end
