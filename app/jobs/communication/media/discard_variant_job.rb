class Communication::Media::DiscardVariantJob < Communication::Website::BaseJob
  queue_as :default

  def perform(variant)
    Communication::Media.discard_variant(variant)
  end
end