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
      objects_types.each do |type|
        objects = objects_by(type)
        puts_red "Migration of #{type} (#{objects.count})"
        objects.find_each do |object|
          migrate_object(object)
        end
      end
    end

    def migrate_object(object)
      puts object
    end

    protected

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