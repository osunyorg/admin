class Ability::Contributor < Ability::Author

  def initialize(user)
    super
    cannot :publish, Communication::Website::Post
    cannot :publish, Communication::Website::Agenda::Event
    cannot :publish, Communication::Website::Agenda::Exhibition
    cannot :publish, Communication::Website::Portfolio::Project
    cannot :publish, Communication::Website::Jobboard::Job
  end

  protected

  # Hérite des règles d'author, mais scopées sur les sites où l'utilisateur est
  # contributor (l'override est résolu dynamiquement, y compris pendant `super`).
  def managed_websites_ids
    @managed_websites_ids ||= scoped_ids(:contributor)
  end

end