class Communication::Website::Page::Accessibility < Communication::Website::Page

  def draftable?
    false
  end

  def is_listed_among_children?
    false
  end

  def default_menu_identifier
    'legal'
  end

  def generate_from_template(l10n)
    generate_declaration(l10n)
    generate_results(l10n)
    generate_conformity(l10n)
    generate_unaccessible(l10n)
    generate_conditions(l10n)
    generate_environment(l10n)
    generate_problem(l10n)
  end

  protected

  def generate_declaration(l10n)
    l10n.generate_block(:title, title: 'Déclaration d\'accessibilité')
    l10n.generate_block(:files, data: {
      description: "<p>#{website} s'engage à rendre son site internet accessible conformément à l'article 47 de la loi n° 2005-102 du 11 février 2005.</p><p>Cette déclaration d'accessibilité s'applique au site #{website.url}.</p>",
      elements: [
        { title: "Schéma pluriannuel d’accessibilité", file: {} },
        { title: "Plan annuel d’accessibilité", file: {} },
      ]
    })
  end

  def generate_results(l10n)
    l10n.generate_block(:title, title: 'Résultats des tests')
    l10n.generate_block(:key_figures, data: {
      description: "<p>Le contre-audit de conformité, finalisé le 00/00/0000 par la société [nom de la société], révèle que :</p>",
      elements:[
        { number: nil, unit: "%", description: "de conformité au RGAA" },
        { number: nil, unit: "",  description: "critères applicables sur un total de 106" }
      ]
    })
  end

  def generate_conformity(l10n)
    l10n.generate_block(:title, title: 'État de conformité')
    l10n.generate_block(:chapter, data: {
      text: "<p>Le site #{website} (#{website.url}) est <b>[non conforme, partiellement conforme, totalement conforme]</b> avec le référentiel général d’amélioration de l’accessibilité (RGAA), version 4 en raison des non-conformités et des dérogations énumérées ci-dessous.</p>"
    })
  end

  def generate_unaccessible(l10n)
    l10n.generate_block(:title, title: 'Contenus non accessibles')
    l10n.generate_block(:chapter, data: {
      text: "<p>Les contenus listés ci-dessous ne sont pas accessibles pour les raisons suivantes.<br></p><p><b>Dérogations pour charge disproportionnée</b></p><ul><li></li></ul><p><b>Contenus non soumis à l'obligation d'accessibilité</b></p><ul><li></li></ul>"
    })
  end

  def generate_conditions(l10n)
    l10n.generate_block(:title, title: 'Établissement de cette déclaration d\'accessibilité')
    l10n.generate_block(:chapter, data: {
      text: "<p>Cette déclaration a été établie le <b>00/00/0000</b>.<br></p><p>Technologies utilisées pour la réalisation du site :</p><ul>\n<li>HTML5</li>\n<li>CSS</li>\n<li>Javascript</li>\n<li>Hugo</li>\n</ul><p>Agents utilisateurs et technologies d'assistance utilisés pour vérifier l'accessibilité :</p><ul>\n<li>NVDA</li>\n<li>VoiceOver</li>\n</ul><p>La vérification de l'accessibilité a été effectuée au travers de tests manuels, assistés par les outils suivants :</p><ul>\n<li>Accessibility Insights for Web</li>\n<li>ArcToolkit</li>\n<li>Assistant RGAA</li>\n<li>Axe DevTool</li>\n<li>Color Contrast Analyser</li>\n<li>eAccessibility (PDF accessibility checker)</li>\n<li>Inspecteur de composants</li>\n<li>Web Developer Toolbar</li>\n<li>WCAG Contrast checker</li>\n<li>Validateur HTML du W3C</li>\n</ul><ul>\n</ul><p>Pages du site ayant fait l'objet de la vérification de conformité</p><ul>\n<li></li>\n</ul>"
    })
  end

  def generate_environment(l10n)
    l10n.generate_block(:title, title: 'Environnement de test')
    l10n.generate_block(:chapter, data: {
      text: "<p>Les vérifications de restitution de contenus ont été réalisées sur la base de la combinaison fournie par la base de référence du RGAA, avec les versions suivantes :</p><ul>\n<li>Sur ordinateur MacOS avec Google Chrome et VoiceOver</li>\n<li>Sur ordinateur MacOS avec Safari et VoiceOver</li>\n<li>Sur ordinateur Windows avec Firefox et NVDA</li>\n<li>Sur mobile Android avec Google Chrome et Talkback</li>\n</ul>"
    })
  end

  def generate_problem(l10n)
    l10n.generate_block(:title, title: 'Voies de recours')
    l10n.generate_block(:chapter, data: {
      text: "<p>Si vous avez signalé au responsable du site internet un défaut d'accessibilité qui vous empêche d'accéder à un contenu ou à un des services du portail et n'avez pas obtenu de réponse satisfaisante, vous êtes en droit de :</p><p><b></b></p><ul>\n<li><p><a href=\"https://formulaire.defenseurdesdroits.fr/\" target=\"_blank\">Écrire un message au Défenseur des droits</a> (formulaire en ligne) ;</p></li>\n<li><p>Contacter le <a href=\"https://www.defenseurdesdroits.fr/saisir/delegues\" target=\"_blank\">délégué du Défenseur des droits dans votre région</a> ;</p></li>\n<li><p>Envoyer un courrier postal (gratuit, ne pas mettre de timbre) à cette adresse : Défenseur des droits - Libre réponse 71120 - 75342 Paris CEDEX 07.</p></li>\n</ul><ul>\n</ul>"
    })
  end

end
