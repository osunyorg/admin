class SetAboutFromMenuItemKind < ActiveRecord::Migration[7.0]
  def change
    mapping = {
      programs: Communication::Website::Page::EducationProgram,
      diplomas: Communication::Website::Page::EducationDiploma,
      posts: Communication::Website::Page::CommunicationPost,
      organizations: Communication::Website::Page::Organization,
      persons: Communication::Website::Page::Person,
      administrators: Communication::Website::Page::Administrator,
      authors: Communication::Website::Page::Author,
      researchers: Communication::Website::Page::Researcher,
      teachers: Communication::Website::Page::Teacher,
      volumes: Communication::Website::Page::ResearchVolume,
      papers: Communication::Website::Page::ResearchPaper
    }

    websites = Communication::Website.where(id: Communication::Website::Menu::Item.where(kind: mapping.keys).distinct.pluck(:website_id))
    Communication::Website::Menu::Item.includes(:website).where(kind: mapping.keys).find_each do |menu_item|
      page_class = mapping[menu_item.kind.to_sym]
      about = menu_item.website.special_page(page_class)
      menu_item.update(about: about, kind: :page)
    end
    websites.find_each(&:sync_with_git)
  end
end
