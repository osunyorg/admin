class Communication::Website::Page::CleanAfterReorderJob < Communication::Website::BaseJob
  queue_as :cats

  def execute
    @website.clean_after_reorder_safely(
      options[:previous_parent_id],
      options[:parent_id],
      options[:language]
    )
  end

end
