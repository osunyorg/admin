# Ce n'est pas un Job qui hérite de Communication::Website::BaseJob,
# il n'y a pas de besoin de lock ni de lien avec un site en particulier.
class Communication::Website::Post::PublishJob < ApplicationJob
  def perform(post)
    Communication::Website::GitFile::IdentifyJob.perform_now(post)
  end
end
