module Migrations
  class Headings

    def self.migrate
      begin
        suspend_callbacks
        new.migrate
      ensure
        resume_callbacks
      end
    end

    def migrate
      @objects_migrated = 0
      objects_types.each do |type|
        objects = objects_by(type)
        puts_red "Migration of #{type} (#{objects.count} objects)"
        objects.find_each do |object|
          migrate_object(object)
        end
      end
      "Migration done (#{@objects_migrated})"
    end

    def migrate_object(object)
      return unless object.respond_to? :blocks
      @objects_migrated += 1
      puts object
      position = 0
      object.blocks.without_heading.ordered.each do |block|
        block.update_column :position, position
        position += 1
      end
      object.headings.root.ordered.each do |heading|
        create_block_title(heading, position)
        position += 1 
        heading.blocks.ordered.each do |block|
          block.update_column :position, position
          position += 1  
        end
      end
    end

    protected

    def create_block_title(heading, position)
      block = heading.about.blocks.where(
        template_kind: 'title',
        title: heading.title,
        university: heading.university,
        about: heading.about,
        position: position
      ).first_or_create
    end

    def self.suspend_callbacks
      Communication::Block.skip_callback :save, :after, :connect_and_sync_direct_sources
      Communication::Block::Heading.skip_callback :save, :after, :connect_and_sync_direct_sources
    end

    def self.resume_callbacks
      Communication::Block.set_callback :save, :after, :connect_and_sync_direct_sources
      Communication::Block::Heading.set_callback :save, :after, :connect_and_sync_direct_sources
    end

    def objects_types
      Communication::Block::Heading.pluck(:about_type).uniq
    end

    def object_ids(type)
      Communication::Block::Heading.where(about_type: type).pluck(:about_id).uniq
    end

    def objects_by(type)
      type.constantize.where(id: object_ids(type))
    end

    def puts_red(message)
      puts "\e[31m#{message}\e[0m"
    end
  end
end