# Orphans
# Les orphelins sont les fichiers du référentiel Git, dans content, 
# qui ne proviennent pas d'un git_file d'Osuny.
# Cela peut être normal, mais cela peut être aussi des fichiers mal supprimés.
# 
# Layouts
# Les fichiers de layouts sont les surcharges (override) du thème.
class Git::OrphanAndLayoutAnalyzer
  CONTENT_PATH = 'content/'
  LAYOUT_PATH = 'layouts/'
  SUFFIX = '.html'

  attr_reader :website

  def initialize(website)
    @website = website
  end

  def launch
    return unless repository.valid?
    website.git_file_orphans.destroy_all
    website.git_file_layouts.destroy_all
    files_in_the_repository.each do |path| 
      analyse(path)
    end
    website.update_column :git_files_analysed_at, Time.now
  end

  protected

  def repository
    @repository ||= website.git_repository
  end

  def files_in_the_repository
    @files_in_the_repository ||= repository.files_in_the_repository
  end

  def analyse(path)
    analyse_content(path) if path.start_with?(CONTENT_PATH)
    analyse_layout(path) if path.start_with?(LAYOUT_PATH)
  end

  def analyse_content(path)
    # Il y a un git file, ce fichier n'est pas orphelin
    return if path.in?(website_git_files)
    return unless path.end_with?(SUFFIX)
    Communication::Website::GitFile::Orphan.create(
      path: path,
      website: website,
      university: website.university
    )
  end

  def analyse_layout(path)
    return unless path.end_with?(SUFFIX)
    Communication::Website::GitFile::Layout.create(
      path: path,
      website: website,
      university: website.university
    )
  end

  # Les objets git_files de la base de données, pas les vrais sur Github!
  def website_git_files
    @website_git_files ||= website.git_files.map do |git_file|
      git_file.path
    rescue
      ''
    end
  end
end