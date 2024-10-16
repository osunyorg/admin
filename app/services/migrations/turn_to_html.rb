module Migrations
  class TurnToHtml
    def self.migrate
      begin
        Communication::Block.skip_callback :save, :after, :connect_and_sync_direct_sources
        Communication::Block::Heading.skip_callback :save, :after, :connect_and_sync_direct_sources
        new.migrate
      ensure
        Communication::Block.set_callback :save, :after, :connect_and_sync_direct_sources
        Communication::Block::Heading.set_callback :save, :after, :connect_and_sync_direct_sources
      end
    end

    def migrate
      migrate_summaries
      migrate_definitions_blocks
      migrate_embed_blocks
      migrate_features_blocks
      migrate_gallery_blocks
      migrate_key_figures_blocks
      migrate_links_blocks
      migrate_sound_blocks
      migrate_testimonials_blocks
      migrate_timeline_blocks
      migrate_video_blocks
    end

    protected

    CLASSES_WITH_SUMMARIES = [
      Administration::Location::Localization,
      Communication::Extranet::Post::Localization,
      Communication::Website::Agenda::Category::Localization,
      Communication::Website::Agenda::Event::Localization,
      Communication::Website::Page::Localization,
      Communication::Website::Portfolio::Category::Localization,
      Communication::Website::Portfolio::Project::Localization,
      Communication::Website::Post::Localization,
      Communication::Website::Post::Category::Localization,
      Education::Diploma::Localization,
      Education::Program::Localization,
      Research::Journal::Localization,
      Research::Journal::Paper::Localization,
      Research::Journal::Volume::Localization,
      Research::Laboratory::Axis::Localization,
      University::Organization::Localization,
      University::Person::Localization
    ]

    def migrate_summaries
      CLASSES_WITH_SUMMARIES.each do |klass|
        klass.where.not(summary: [nil, '']).find_each do |object|
          next if object.summary.start_with?('<p>')
          object.update_column :summary, "<p>#{object.summary}</p>"
        end
      end
    end

    def migrate_definitions_blocks
      Communication::Block.definitions.each do |block|
        block.template.elements.each do |element|
          next if element.description.blank?
          next if element.description.start_with?('<p>')
          element.description = "<p>#{element.description}</p>"
        end
        block.data = block.template.data
        block.save
      end
    end

    def migrate_embed_blocks
      Communication::Block.embed.each do |block|
        next if block.template.transcription.blank?
        next if block.template.transcription.start_with?('<p>')
        block.template.transcription = "<p>#{block.template.transcription}</p>"
        block.data = block.template.data
        block.save
      end
    end

    def migrate_features_blocks
      Communication::Block.features.each do |block|
        block.template.elements.each do |element|
          next if element.description.blank? && element.credit.blank?
          unless element.description.start_with?('<p>')
            element.description = "<p>#{element.description}</p>"
          end
          unless element.credit.start_with?('<p>')
            element.credit = "<p>#{element.credit}</p>"
          end
        end
        block.data = block.template.data
        block.save
      end
    end

    def migrate_gallery_blocks
      Communication::Block.gallery.each do |block|
        block.template.elements.each do |element|
          next if element.text.blank? && element.credit.blank?
          unless element.text.start_with?('<p>')
            element.text = "<p>#{element.text}</p>"
          end
          unless element.credit.start_with?('<p>')
            element.credit = "<p>#{element.credit}</p>"
          end
        end
        block.data = block.template.data
        block.save
      end
    end

    def migrate_key_figures_blocks
      Communication::Block.key_figures.each do |block|
        block.template.elements.each do |element|
          next if element.description.blank?
          next if element.description.start_with?('<p>')
          element.description = "<p>#{element.description}</p>"
        end
        block.data = block.template.data
        block.save
      end
    end

    def migrate_links_blocks
      Communication::Block.links.each do |block|
        if block.template.description.present? && !block.template.description.start_with?('<p>')
          block.template.description = "<p>#{block.template.description}</p>"
        end
        block.template.elements.each do |element|
          next if element.description.blank?
          next if element.description.start_with?('<p>')
          element.description = "<p>#{element.description}</p>"
        end
        block.data = block.template.data
        block.save
      end
    end

    def migrate_sound_blocks
      Communication::Block.sound.each do |block|
        next if block.template.transcription.blank?
        next if block.template.transcription.start_with?('<p>')
        block.template.transcription = "<p>#{block.template.transcription}</p>"
        block.data = block.template.data
        block.save
      end
    end

    def migrate_testimonials_blocks
      Communication::Block.testimonials.each do |block|
        block.template.elements.each do |element|
          next if element.text.blank?
          next if element.text.start_with?('<p>')
          element.text = "<p>#{element.text}</p>"
        end
        block.data = block.template.data
        block.save
      end
    end

    def migrate_timeline_blocks
      Communication::Block.timeline.each do |block|
        next if block.template.text.blank?
        next if block.template.text.start_with?('<p>')
        block.template.text = "<p>#{block.template.text}</p>"
        block.data = block.template.data
        block.save
      end
    end

    def migrate_video_blocks
      Communication::Block.video.each do |block|
        next if block.template.transcription.blank?
        next if block.template.transcription.start_with?('<p>')
        block.template.transcription = "<p>#{block.template.transcription}</p>"
        block.data = block.template.data
        block.save
      end
    end

  end
end