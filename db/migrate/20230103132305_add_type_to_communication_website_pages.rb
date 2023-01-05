class AddTypeToCommunicationWebsitePages < ActiveRecord::Migration[7.0]
  def up
    add_column :communication_website_pages, :type, :string
    kinds = {
      '0': :home,
      '10': :communication_posts,
      '20': :education_programs,
      '21': :education_diplomas,
      '30': :research_papers,
      '32': :research_volumes,
      '80': :legal_terms,
      '81': :sitemap,
      '82': :privacy_policy,
      '83': :accessibility,
      '90': :organizations,
      '100': :persons,
      '110': :administrators,
      '120': :authors,
      '130': :researchers,
      '140': :teachers
    }
    full_width_pages = [
      :home,
      :communication_posts,
      :education_programs,
      :research_papers, 
      :research_volumes,
      :organizations,
      :persons,
      :administrators,
      :authors,
      :researchers,
      :teachers
    ]
    Communication::Website::Page.find_each do |page|
      next unless page.kind
      kind = kinds[page.kind.to_s.to_sym]
      type = "Communication::Website::Page::#{kind.to_s.classify}"
      page.update_column :type, type      
      page.update_column :full_width, true if kind.in?(full_width_pages)
    end
  end

  def down
    remove_column :communication_website_pages, :type, :string
  end
end
