class MigrateToRails7Sha256Signature < ActiveRecord::Migration[7.0]
  def up
    Communication::Block.all.find_each { |block|
      crawl(block.data)
      block.save
    }
  end

  protected

  def crawl(enumerable)
    case enumerable
    when Array
      enumerable.each do |item|
        crawl(item) if [Array, Hash].include?(item.class)
      end
    when Hash
      enumerable.keys.each do |key|
        if key == "signed_id"
          # Convert value
          enumerable[key] = convert(enumerable[key]) if key == "signed_id"
        elsif [Array, Hash].include?(enumerable[key].class)
          crawl(enumerable[key])
        end
      end
    end
  end

  def convert(legacy_signed_id)
    begin
      # Try to find blob with the un-modified legacy_signed_id
      blob = ActiveStorage::Blob.find_signed!(legacy_signed_id)
      legacy_signed_id
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      begin
        # Try to find blob with ID from SHA1-signed_id
        key_generator = ActiveSupport::KeyGenerator.new(
          Rails.application.secret_key_base,
          iterations: 1000,
          hash_digest_class: OpenSSL::Digest::SHA1
        )
        key_generator = ActiveSupport::CachingKeyGenerator.new(key_generator)
        secret = key_generator.generate_key("ActiveStorage")
        verifier = ActiveSupport::MessageVerifier.new(secret)

        ActiveStorage::Blob.find_by_id(verifier.verify(legacy_signed_id, purpose: :blob_id)).try(:signed_id)
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        # Blob not found (SHA1 and SHA256), corrupted blob ID, ignore
        legacy_signed_id
      end
    end
  end
end
