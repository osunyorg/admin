module Communication::Website::WithRealmUniversity
  extend ActiveSupport::Concern

  def blocks_from_university
    Communication::Block.where(about: connected_people).or(
      Communication::Block.where(about: connected_organizations)
    )
  end

  def has_organizations?
    connected_organizations.any?
  end

  def has_persons?
    connected_people.any?
  end

end