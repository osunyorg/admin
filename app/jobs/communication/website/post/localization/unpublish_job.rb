# Ce n'est pas un Job qui hérite de Communication::Website::BaseJob,
# il n'y a pas de besoin de lock ni de lien avec un site en particulier.
class Communication::Website::Post::Localization::UnpublishJob < ApplicationJob
  def perform(post_l10n)
    post_l10n.update(
      published: false,
      published_at: nil,
      unpublication_job_id: nil
    )
  end
end
