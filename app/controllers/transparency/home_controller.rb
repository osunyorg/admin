class Transparency::HomeController < Transparency::ApplicationController
  def index
    @universities = University.contributing.ordered
    @contributions_total = University.sum(:contribution_amount)
    @costs = [
      ['Bugsnag', 'Interception d\'erreur (gratuit pour l\'open source)', 0],
      ['CodeClimate', 'Qualité de code (gratuit pour l\'open source)', 0],
      ['Deuxfleurs', 'Hébergement sans data center', 3000],
      ['KeyCDN', 'Redimensionnement des images', 3000],
      ['LanguageTool', 'Aide à la qualité des contenus', 1200],
      ['LibreTranslate', 'Aide à  la traduction', 696],
      ['MicroLink', 'Captures d\'écran', 144],
      ['noesya', 'Tierce maintenance applicative (pro bono, estimée à 60k€)', 0],
      ['Plausible', 'Mesure d\'audience', 100],
      ['Scalingo', 'Hébergement de l\'admin', 3000],
      ['Scaleway', 'Stockage des fichiers', 100]
    ]
    @costs_total = @costs.sum { |cost| cost.last }
    @balance = @contributions_total - @costs_total
  end
end
