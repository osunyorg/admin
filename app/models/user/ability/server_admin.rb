class User::Ability::ServerAdmin < User::Ability

  def initialize(user)
    super
    can :manage, :all
  end
end