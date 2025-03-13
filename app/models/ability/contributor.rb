class Ability::Contributor < Ability::Author

  def initialize(user)
    super
    cannot :publish, Communication::Website::Post
    cannot :publish, Communication::Website::Agenda::Event
    cannot :publish, Communication::Website::Agenda::Exhibition
    cannot :publish, Communication::Website::Portfolio::Project
  end

end