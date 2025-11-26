class Communication::Website::SynchronizeListBlocksJob < ApplicationJob
  queue_as :whales

  def perform(website, template_kind)
    abouts(website, template_kind).each do |about|
      generate_git_files_for_about(about)
    end
    # about_ids_by_about_type(website, template_kind).each do |about_type, about_ids|
    #   generate_git_files_for_about_type_and_ids(about_type, about_ids)
    # end
  end

  private

  def abouts(website, template_kind)
    website.blocks
           .where(template_kind: template_kind)
           .map { |block| block.about }
           .distinct
  end

  def generate_git_files_for_about(about)
    about.websites.each do |website|
      website.generate_git_file_for_object(about)
    end
  end

  # def generate_git_files_for_about_type_and_ids(about_type, about_ids)
  #   about_class = about_type.safe_constantize
  #   about_class.where(id: about_ids).find_each do |about|
  #     generate_git_files_for_about(about)
  #   end
  # end

  # def about_ids_by_about_type(website, template_kind)
  #   @about_ids_by_about_type ||= begin
  #     # [[type1, id1], [type1, id2], [type2, id3], ...]
  #     list_of_about_types_and_ids = website.blocks.where(template_kind: template_kind).distinct.pluck(:about_type, :about_id)
  #     # { type1 => [[type1, id1], [type1, id2]], type2 => [[type2, id3]], ... }
  #     list_grouped_by_about_type = list_of_about_types_and_ids.group_by { |about_type, _| about_type }
  #     # { type1 => [id1, id2], type2 => [id3], ... }
  #     list_grouped_by_about_type.transform_values do |type_and_ids|
  #       type_and_ids.map { |_, about_id| about_id }
  #     end
  #   end
  # end
end
