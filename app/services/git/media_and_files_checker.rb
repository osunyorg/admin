# Vérifie que les git_files des médias et des fichiers marqués comme à jour
# (synchronisés) correspondent bien à un fichier réellement présent sur le
# dépôt Git du site.
#
# Les médias sont portés par les blobs (data/media/xx/id.yml), les fichiers
# par leurs localizations (content/<langue>/files/<année>/<slug>.html).
#
# Le coût Github est de 2 appels par site (la branche puis l'arbre récursif),
# quel que soit le nombre de git_files à vérifier.
class Git::MediaAndFilesChecker
  MEDIA_ABOUT_TYPE = 'ActiveStorage::Blob'.freeze
  FILE_ABOUT_TYPE = 'Communication::File::Localization'.freeze
  ABOUT_TYPES = [MEDIA_ABOUT_TYPE, FILE_ABOUT_TYPE].freeze

  attr_reader :website

  # Les git_files concernés : médias et fichiers, indiqués comme à jour.
  def self.git_files
    Communication::Website::GitFile.synchronized
                                  .where(about_type: ABOUT_TYPES)
  end

  # Les sites qui ont au moins un git_file à vérifier, sur un dépôt listable.
  def self.websites
    Communication::Website.github
                          .with_repository
                          .where(id: git_files.select(:website_id))
  end

  def initialize(website)
    @website = website
  end

  # Renvoie les git_files dont le fichier est absent du dépôt.
  # Renvoie un tableau vide si le dépôt n'est pas vérifiable (voir skip_reason).
  def missing_git_files
    return [] if skip_reason.present?
    git_files.reject { |git_file| present_on_git?(git_file) }
  end

  # Nil si on peut conclure, sinon la raison pour laquelle on ne peut pas.
  def skip_reason
    return @skip_reason if defined?(@skip_reason)
    @skip_reason = compute_skip_reason
  end

  def report
    return "#{website} : ignoré (#{skip_reason})." if skip_reason.present?
    missing = missing_git_files
    return "#{website} : #{git_files.size} git_files vérifiés, aucun fichier manquant." if missing.empty?
    lines = missing.map { |git_file|
      "  - #{git_file.about_type} #{git_file.about_id} : #{path_for(git_file)}"
    }
    "#{website} : #{missing.size} fichier(s) manquant(s) sur #{git_files.size} git_files vérifiés.\n#{lines.join("\n")}"
  end

  protected

  def git_files
    @git_files ||= self.class.git_files.where(website_id: website.id).to_a
  end

  def compute_skip_reason
    return 'aucun git_file à vérifier' if git_files.empty?
    return 'dépôt invalide' unless git_repository.valid?
    # Sans liste fiable, on ne peut pas conclure à l'absence d'un fichier.
    return 'arbre du dépôt tronqué' unless git_repository.files_in_the_repository_reliable?
    nil
  end

  def present_on_git?(git_file)
    path = path_for(git_file)
    path.present? && paths_on_git.include?(path)
  end

  # Un git_file synchronisé a le même current_path et previous_path,
  # mais on reste tolérant aux données anciennes.
  def path_for(git_file)
    git_file.current_path.presence || git_file.previous_path.presence
  end

  # Un seul appel à l'arbre du dépôt, quel que soit le nombre de git_files.
  def paths_on_git
    @paths_on_git ||= git_repository.files_in_the_repository.to_set
  end

  def git_repository
    @git_repository ||= website.git_repository
  end
end
