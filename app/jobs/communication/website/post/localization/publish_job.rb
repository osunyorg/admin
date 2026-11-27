# Ce n'est pas un Job qui hérite de Communication::Website::BaseJob,
# il n'y a pas de besoin de lock ni de lien avec un site en particulier.
class Communication::Website::Post::Localization::PublishJob < ApplicationJob
  def perform(post_l10n)
    # On génère l'actualité avec ses dépendances
    Communication::Website::GitFile::IdentifyJob.perform_now(post_l10n.about)
    # On synchronise les blocs actualités pour chaque site associé à l'actualité publiée
    post_l10n.about.synchronize_list_blocks

    post_l10n.update_column :publication_job_id, nil
  end
end
