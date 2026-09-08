module Communication::Website::WithRealmCommunication
  extend ActiveSupport::Concern

  included do
    has_many    :permalinks,
                class_name: "Communication::Website::Permalink",
                dependent: :destroy

    has_many    :communication_blocks,
                class_name: "Communication::Block",
                foreign_key: :communication_website_id
    alias       :blocks :communication_blocks
  end

  def all_blocks
    @all_blocks ||= Communication::Block.where(id: all_blocks_ids)
  end

  protected

  def all_blocks_ids
    @all_blocks_ids ||= (
      blocks.pluck(:id) +
      blocks_from_education.pluck(:id) +
      blocks_from_research.pluck(:id) +
      blocks_from_university.pluck(:id)
    ).compact_blank.uniq
  end
end
