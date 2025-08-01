# Les objets ont souvent besoin de WithDependencies, mais pas toujours :
# - les blocks ont des dépendances, mais ne sont pas envoyés sur Git en tant qu'objets, ils passent par leur 'about'
# - les menu items passent par le menu
# - les templates et les components de blocks passent par les blocks qui passent par les 'about'
module WithDependencies
  extend ActiveSupport::Concern

  included do
    attr_accessor :previous_dependencies

    if self < ActiveRecord::Base
      after_save :clean_websites_if_necessary
    end
  end

  def destroy
    # On est obligés d'overwrite la méthode destroy pour éviter un problème d'œuf et de poule.
    # On a besoin que les websites puissent recalculer leurs recursive_dependencies
    # et on a besoin que ces recursive_dependencies n'incluent pas l'objet courant, puisqu'il est "en cours de destruction" (ni ses propres recursive_dependencies).
    # Mais si on détruit juste l'objet et qu'on fait un `after_destroy :clean_website_connections`
    # on ne peut plus accéder aux websites (puisque l'objet est déjà détruit et ses connexions en cascades).
    # Egalement, quand on supprime un objet indirect, il faut synchroniser ses anciennes sources directes pour supprimer toute référence éventuelle
    # Donc :
    # 1. on stocke les websites (et les sources directes si nécessaire)
    # 2. on laisse la méthode destroy normale faire son travail
    # 3. PUIS on demande aux websites stockés de nettoyer leurs connexions et leurs git files (et on synchronise les potentielles sources directes)
    transaction do
      references_before_destroy = references.compact
      website_ids_before_destroy = websites_to_clean_ids
      super
      references_before_destroy.each &:touch
      clean_websites(website_ids_before_destroy)
    end
  end

  # Cette méthode doit être définie dans chaque objet,
  # et renvoyer un tableau de ses références directes.
  # Jamais de référence indirecte !
  # Elles sont gérées récursivement.
  def dependencies
    []
  end

  def references
    []
  end

  # On ne liste pas les objets en cours de suppression
  # Par défaut, on ne suit pas les objets directs, parce qu'ils se gèrent de façon autonome.
  def recursive_dependencies(array: [], skip_direct: true)
    if dependency_published?(self)
      dependencies.each do |dependency|
        array = recursive_dependencies_add(array, dependency, skip_direct)
      end
    end
    array.compact
  end

  # On garde cette méthode pour la memoization
  def recursive_dependencies_following_direct
    @recursive_dependencies_following_direct ||= recursive_dependencies(skip_direct: false)
  end

  def clean_websites_if_necessary_safely
    # Tableau de global ids des dépendances
    current_dependencies = DependenciesFilter.filtered(recursive_dependencies)
    # La première fois, il n'y a rien en cache, alors on force le nettoyage
    previous_dependencies = Rails.cache.read(dependencies_cache_key)
    # Les dépendances obsolètes sont celles qui étaient dans les dépendances avant la sauvegarde,
    # stockées dans le cache précédemment, et qui n'y sont plus maintenant
    obsolete_dependencies = previous_dependencies - current_dependencies if previous_dependencies
    # S'il y a des dépendances obsolètes, on lance le nettoyage
    # Si l'objet est dépublié, on lance aussi
    should_clean = previous_dependencies.nil? || unpublished_by_last_save? || obsolete_dependencies.any?
    clean_websites(websites_to_clean_ids) if should_clean
    # On enregistre les dépendances pour la prochaine sauvegarde
    Rails.cache.write(dependencies_cache_key, current_dependencies)
  end

  protected

  def recursive_dependencies_add(array, dependency, skip_direct)
    # Si l'objet ne doit pas être ajouté on n'ajoute pas non plus ses dépendances récursives
    # C'est le fait de couper ici qui évite la boucle infinie
    return array unless dependency_should_be_added?(array, dependency)
    array << dependency if dependency.is_a?(ActiveRecord::Base)
    # Si l'objet est direct, il est déjà géré ailleurs, donc on n'a pas besoin de le suivre.
    return array if skip_direct && dependency.try(:is_direct_object?)
    return array unless dependency.respond_to?(:recursive_dependencies)
    dependency.recursive_dependencies(array: array, skip_direct: skip_direct)
  end

  # Si l'objet est déjà là, on ne doit pas l'ajouter
  # Si l'objet n'est pas publié, on ne doit pas l'ajouter non plus
  def dependency_should_be_added?(array, dependency)
    !dependency.in?(array) && dependency_published?(dependency)
  end
  
  # Les objets qui n'ont pas pas de méthode published (website, menu, blob) sont publiés par défaut
  def dependency_published?(dependency)
    if dependency.respond_to?(:published?)
      dependency.published?
    else
      true
    end
  end

  def clean_websites_if_necessary
    Dependencies::CleanWebsitesIfNecessaryJob.perform_later(self)
  end

  # "gid://osuny/Education::Program/c537fc50-f7c5-414f-9966-3443bc9fde0e-dependencies"
  def dependencies_cache_key
    "#{to_gid}-dependencies"
  end

  def clean_websites(websites_ids)
    # Les objets directs et les objets indirects (et les websites) répondent !
    return unless respond_to?(:is_direct_object?)
    websites_ids.each do |website_id|
      Communication::Website.find(website_id).clean
    end
  end

  def websites_to_clean_ids
    websites.pluck(:id)
  end

  def unpublished_by_last_save?
    return unless respond_to?(:published)
    return true if saved_change_to_published? && !published?
    if respond_to?(:published_at)
      return saved_change_to_published_at? && (published_at.nil? || published_at > Time.now)
    end
    false
  end
end