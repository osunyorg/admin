module Migrations
  class FixKeyFigures
    def self.migrate
      begin
        suspend_callbacks
        new.migrate
      ensure
        resume_callbacks
      end
    end

    def migrate
      Communication::Block.template_key_figures.each do |block|
        block.template.elements.each do |element|
          next if element.description.blank?
          puts element.description
          string = ActionController::Base.helpers.strip_tags(element.description.to_s)
          puts "-> #{string}"
          element.description = string
        end
        block.data = block.template.data
        block.save
      end
    end

    protected

    def self.suspend_callbacks
      Communication::Block.skip_callback :save, :after, :connect_and_sync_direct_sources
      Communication::Block.skip_callback :save, :after, :clean_websites_if_necessary
      Communication::Block.skip_callback :save, :after, :touch_about
    end

    def self.resume_callbacks
      Communication::Block.set_callback :save, :after, :connect_and_sync_direct_sources
      Communication::Block.set_callback :save, :after, :clean_websites_if_necessary
      Communication::Block.set_callback :save, :after, :touch_about
    end
  end
end