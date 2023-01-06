class SetAboutFromMenuItemKind < ActiveRecord::Migration[7.0]
  def change
    mapping = {
      '30' => Communication::Website::Page::EducationProgram,
      '32' => Communication::Website::Page::EducationDiploma,
      '40' => Communication::Website::Page::CommunicationPost,
      '45' => Communication::Website::Page::Organization,
      '50' => Communication::Website::Page::Person,
      '51' => Communication::Website::Page::Administrator,
      '52' => Communication::Website::Page::Author,
      '53' => Communication::Website::Page::Researcher,
      '54' => Communication::Website::Page::Teacher,
      '60' => Communication::Website::Page::ResearchVolume,
      '62' => Communication::Website::Page::ResearchPaper
    }

    websites = Communication::Website.where(id: Communication::Website::Menu::Item.where(kind: mapping.keys).distinct.pluck(:website_id))
    Communication::Website::Menu::Item.includes(:website).where(kind: mapping.keys.map(&:to_i)).find_each do |menu_item|
      page_class = mapping[menu_item.kind_before_type_cast.to_s]
      about = menu_item.website.special_page(page_class)
      menu_item.update(about: about, kind: :page)
    end
    websites.find_each(&:sync_with_git)
  end
end
