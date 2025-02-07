class Ability::ServerAdmin < Ability

  def initialize(user)
    super
    can :manage, :all
    cannot :read, User, role: :server_admin
  end
end