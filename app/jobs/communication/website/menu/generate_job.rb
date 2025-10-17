# Ce n'est pas un Job qui hérite de Communication::Website::BaseJob,
# il n'y a pas de besoin de lock ni de lien avec un site en particulier.
class Communication::Website::Menu::GenerateJob < ApplicationJob
  def perform(menu)
    menu.generate_automatically_safely
  end
end
