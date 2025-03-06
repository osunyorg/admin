class Transparency::HomeController < Transparency::ApplicationController
  def index
    @universities = University.contributing.ordered
    @contributions_total = University.sum(:contribution_amount)
    @costs = [
      ['Brevo', 'SMS et mails transactionnels', 420],
      ['CodeClimate', 'Qualité de code (gratuit pour l\'open source)', 0],
      ['Deuxfleurs', 'Hébergement sans data center', 3000],
      ['Insight Hub', 'Interception d\'erreur (gratuit pour l\'open source)', 0],
      ['KeyCDN', 'Redimensionnement des images', 6000],
      ['LanguageTool', 'Aide à la qualité des contenus', 1200],
      ['LibreTranslate', 'Aide à  la traduction', 660],
      ['MicroLink', 'Captures d\'écran', 144],
      ['noesya', 'Tierce maintenance applicative (pro bono, estimée à 60k€)', 0],
      ['Plausible', 'Mesure d\'audience', 948],
      ['Scalingo', 'Hébergement de l\'admin', 6700],
      ['Scaleway', 'Stockage des fichiers', 20]
    ]
    @costs_total = @costs.sum { |cost| cost.last }
    @balance = @contributions_total - @costs_total
  end
end
