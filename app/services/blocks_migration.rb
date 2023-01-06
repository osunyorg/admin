class BlocksMigration

  def self.cleanup
    Communication::Block.all.find_each { |block|
      self.crawl(block.data)
      block.save
    }
  end

  protected

  def self.crawl(enumerable)
    case enumerable
    when Array
      enumerable.each do |item|
        crawl(item) if [Array, Hash].include?(item.class)
      end
    when Hash
      enumerable.keys.each do |key|
        if key == "signed_id"
          # Convert value
          enumerable[key] = ActiveStorageKeyConverter.convert(enumerable[key]) if key == "signed_id"
        elsif [Array, Hash].include?(enumerable[key].class)
          crawl(enumerable[key])
        end
      end
    end
  end

end