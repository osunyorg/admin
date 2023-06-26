class ContentMigration

  def self.migrate(university_id)
    begin
      Communication::Block.skip_callback :save, :after, :connect_and_sync_direct_sources
      Communication::Block::Heading.skip_callback :save, :after, :connect_and_sync_direct_sources
      university = University.find(university_id)
      ContentMigration.new(university).migrate_all
    ensure
      Communication::Block.set_callback :save, :after, :connect_and_sync_direct_sources
      Communication::Block::Heading.set_callback :save, :after, :connect_and_sync_direct_sources
    end
  end

  def initialize(university)
    @university = university
  end

  def migrate_all
    about_types.each do |about_type|
      migrate_objects(about_type)
    end
  end

  def migrate(object)
    puts "----------------------[migration] #{object} - #{object.class} - #{object.id}"
    heading = nil
    heading_position = 0
    object.blocks.published.ordered.each do |block|
      # ignore blocks already inside headings
      next if block.heading.present?
      # Move title from block to heading
      if should_add_heading?(block)
        heading = object.headings.create(university: object.university)
        heading.title = block.title
        heading.position = heading_position
        heading.save
        heading_position += 1
        block.title = ''
        block.save
      end
      puts "----------------------[migration] block #{block.id} - #{block.template_kind}"
      # Add blocks to current heading
      block.heading = heading
      block.save
    end
  end

  protected

  def should_add_heading?(block)
    block.title.present? && 
    # these blocks keep their title
    !block.call_to_action? &&
    !block.post? &&
    !block.page?
  end

  def about_types
    Communication::Block.distinct.pluck(:about_type).uniq
  end

  def about_ids(about_type)
    Communication::Block.distinct.where(about_type: about_type).pluck(:about_id).uniq
  end

  def migrate_objects(about_type)
    about_ids(about_type).each do |about_id|
      object = about_type.constantize.find_by(id: about_id)
      migrate(object) if object.present? && object.university == @university
    end
  end

end