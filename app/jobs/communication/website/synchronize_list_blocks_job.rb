class Communication::Website::SynchronizeListBlocksJob < ApplicationJob
  queue_as :whales

  def perform(website, template_kind)
    abouts(website, template_kind).each do |about|
      website.generate_git_file_for_object(about)
    end
  end

  private

  def abouts(website, template_kind)
    website.blocks
           .where(template_kind: template_kind)
           .map { |block| block.about }
           .uniq
  end

end
