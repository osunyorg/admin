class RefactorOptionsJob < ApplicationJob
  queue_as :default

  def perform
    # Options
    Communication::Block.agenda.find_each do |block|
      template = block.template
      template.option_categories    = template.show_category
      template.option_summary       = template.show_summary
      template.option_status        = template.show_status
      block.save
    end
    Communication::Block.organizations.find_each do |block|
      template = block.template
      template.option_link          = template.with_link
      block.save
    end
    Communication::Block.pages.find_each do |block|
      template = block.template
      template.option_image         = template.show_image
      template.option_summary       = template.show_description
      template.option_main_summary  = template.show_main_description
      block.save
    end
    Communication::Block.persons.find_each do |block|
      template = block.template
      template.option_image         = template.with_photo
      template.option_link          = template.with_link
      block.save
    end
    Communication::Block.posts.find_each do |block|
      template = block.template
      template.option_author        = !template.hide_author
      template.option_categories    = !template.hide_category
      template.option_date          = !template.hide_date
      template.option_image         = !template.hide_image
      template.option_summary       = !template.hide_summary
      block.save
    end
    # Headings (pas de lien avec les options)
    Communication::Block::Heading.where(slug: nil).find_each do |heading|
      heading.set_slug
      heading.update_column :slug, heading.slug
    end
  end
end
