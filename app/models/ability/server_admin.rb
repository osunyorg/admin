class Ability::ServerAdmin < Ability

  def initialize(user)
    super
    can :manage, :all
  end
end