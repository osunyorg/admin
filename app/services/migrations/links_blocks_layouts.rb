class Migrations::LinksBlocksLayouts
  def self.migrate
    begin
      suspend_callbacks
      new.migrate
    ensure
      resume_callbacks
    end
  end

  def migrate
    Communication::Block.template_links.where("data->>'layout' IS NULL").find_each do |block|
      # Update data to set cards layout
      block.template.layout = "cards"
      block.data = block.template.data
      block.save

      # Generate git files
      Communication::Website::GitFile::IdentifyJob.perform_later(block.about)
    end
  end

  protected

  def self.suspend_callbacks
    Communication::Block.skip_callback :save, :after, :connect_to_websites
    Communication::Block.skip_callback :save, :after, :clean_websites_if_necessary
    Communication::Block.skip_callback :save, :after, :touch_about
  end

  def self.resume_callbacks
    Communication::Block.set_callback :save, :after, :connect_to_websites
    Communication::Block.set_callback :save, :after, :clean_websites_if_necessary
    Communication::Block.set_callback :save, :after, :touch_about
  end
end
