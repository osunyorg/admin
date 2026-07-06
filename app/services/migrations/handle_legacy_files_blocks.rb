class Migrations::HandleLegacyFilesBlocks
  def self.migrate
    puts 'Migrations::HandleLegacyFilesBlocks - Starting migration'
    new.migrate
  end

  def initialize
    @processed_blocks = 0
    @created_localizations = 0
  end

  def migrate
    # Find all Communication::Block with template_kind "files" (which is 55)
    Communication::Block.where(template_kind: :files).find_each do |block|
      process_block(block)
    end

    puts "Processed #{@processed_blocks} blocks"
    puts "Created #{@created_localizations} Communication::File::Localization records"
  end

  protected

  def process_block(block)
    return if block.data.blank? || block.data['elements'].blank?

    @processed_blocks += 1
    puts "Processing block #{block.id} with language #{block.language}"

    block.data['elements'].each do |element_data|
      next if element_data.blank? || element_data['file'].blank?

      file_data = element_data['file']
      next if file_data['signed_id'].blank?

      begin
        process_file_element(file_data, block)
      rescue => e
        puts "Error processing file element in block #{block.id}: #{e.message}"
        next
      end
    end
  end

  def process_file_element(file_data, block)
    signed_id = file_data['signed_id']
    filename = file_data['filename']
    language = block.language

    puts "  Processing file with signed_id: #{signed_id[0..20]}... (filename: #{filename})"

    # Find the ActiveStorage blob by signed_id
    blob = ActiveStorage::Blob.find_signed!(signed_id)

    # Create or find the Communication::File and Localization
    localization = Communication::File::Localization.create_from_blob(blob, language)

    # Update the element data to reference the new Communication::File
    file_data['id'] = localization.about_id
    file_data['signed_id'] = '' # Clear the signed_id as it's no longer needed

    # Save the updated block data
    block.save! if block.changed?

    if localization.saved_change_to_id?
      @created_localizations += 1
    end

    puts "  Created Communication::File #{localization.about_id} with localization #{localization.id}"
  end
end
