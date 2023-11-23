class Ability::Contributor < Ability::Author

  def initialize(user)
    super
    cannot :publish, Communication::Website::Agenda::Event
    cannot :publish, Communication::Website::Post
  end

end