class Communication::Website::CleanAfterPagesReorderJob < Communication::Website::BaseJob
  queue_as :cats

  def execute
    @website.clean_after_pages_reorder_safely(
      options[:previous_parent_id],
      options[:parent_id],
      options[:language]
    )
  end

end
