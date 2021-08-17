University.create name: 'Osuny', identifier: 'osuny'

Administration::Qualiopi::Criterion.destroy_all
Administration::Qualiopi::Criterion.create [
  {
    id: '0285619c-cfc8-4858-bef6-74adc0aac055',
    number: 1,
    name: 'Les conditions d’information du public sur les prestations proposées, les délais pour y accéder et les résultats obtenus'
  },
  {
    id: 'd0127e8f-d121-4a02-a280-275e1e060573',
    number: 2,
    name: 'L’identification précise des objectifs des prestations proposées et l’adaptation de ces prestations aux publics bénéficiaires lors de la conception des prestations'
  },
  {
    id: '50168ad5-ef10-43cd-a76e-050278e99705',
    number: 3,
    name: 'L’adaptation aux publics bénéficiaires des prestations et des modalités d’accueil, d’accompagnement, de suivi et d’évaluation mises en œuvre'
  },
  {
    id: '4207cf14-b32f-4ee3-a0e9-5a472801e4d3',
    number: 4,
    name: 'L’adéquation des moyens pédagogiques, techniques et d’encadrement aux prestations mises en œuvre'
  },
  {
    id: '79185ec5-4249-48ce-994f-6ca3750139e6',
    number: 5,
    name: 'La qualification et le développement des connaissances et compétences des personnels chargés de mettre en œuvre les prestations'
  },
  {
    id: 'b87aa3c2-37d6-4576-ae2c-e5ea2a74e7e4',
    number: 6,
    name: 'L’inscription et l’investissement du prestataire dans son environnement professionnel'
  },
  {
    id: 'fcd31ee6-a512-4e1a-9ff2-6f67b5c3d61d',
    number: 7,
    name: 'Le recueil et la prise en compte des appréciations et des réclamations formulées par les parties prenantes aux prestations délivrées'
  }
]

Administration::Qualiopi::Indicator.destroy_all
Administration::Qualiopi::Indicator.create [
  {
    id: 'f5632d1a-09f1-4cd1-98d1-c6de4b7728d6',
    criterion_id: '0285619c-cfc8-4858-bef6-74adc0aac055',
    number: 1,
    name: 'Le prestataire diffuse une information accessible au public, détaillée et vérifiable sur les prestations proposées : prérequis, objectifs, durée, modalités et délais d’accès, tarifs, contacts, méthodes mobilisées et modalités d’évaluation, accessibilité aux personnes handicapées.',
    level_expected: 'Donner une information accessible, exhaustive (c’est-à-dire sur l’intégralité des items mentionnés) datée et actualisée.',
    proof: 'Tous supports et outils d’information (plaquette, réseaux sociaux, sites internet, supports de publicité, salons, supports de contractualisation, conditions générales de vente). Pour les PSH, livret d’accueil, registre public d’accessibilité, conditions d’accès.

    Pour les CBC : tout support rappelant le cadre légal et réglementaire du bilan de compétences, ses objectifs, son financement.',
    requirement: 'VAE : les contraintes et exigences de la démarche sont clairement formalisées et communiquées, notamment les modalités d’instruction et de faisabilité (c’est à dire le processus à suivre pour effectuer la demande d’éligibilité). Concernant les diplômes de l’Education nationale, les modalités de l’étude personnalisée, partie intégrante de la recevabilité, est communiquée.

    CBC : les prérequis n’ont pas à être mentionnés.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une information partiellement accessible ou par l’absence ponctuelle et non répétitive de certains items dans la communication.',
    glossary: 'Prérequis : préalables nécessaires ou indispensables pour bénéficier d’une prestation déterminée. L’absence de prérequis doit être mentionnée.

    Objectifs : énoncé des aptitudes et compétences, visées et évaluables, qui seront acquises au cours de la prestation.

    Aptitude : capacité d’appliquer un savoir et d’utiliser un savoir-faire pour réaliser des tâches et résoudre des problèmes.

    Compétences : capacité avérée de mettre en œuvre des savoirs, des savoir-faire et des dispositions personnelles, sociales ou méthodologiques dans des situations de travail ou d’études/formations, pour le développement professionnel ou personnel.

    Durée : la durée peut être exprimée en heure ou en jour. Elle peut également être forfaitisée ou estimée.

    Délai d’accès : durée estimée entre la demande du bénéficiaire et le début de la prestation.

    Tarifs : Prix de la prestation ou conditions tarifaires.

    Méthodes mobilisées : modalités pédagogiques et/ou moyens et/ou outils utilisés pour mener à bien la prestation dispensée.

    Modalités d’évaluation : moyens mobilisés pour mesurer à l’aide de critères objectifs les acquis du bénéficiaire en cours et/ou à la fin de la prestation.

    Accessibilité : conditions d’accueil et d’accès des publics en situation de handicap (locaux, adaptation des moyens de la prestation).'
  },
  {
    id: '239a7a91-f7ae-4e6c-a5c5-d0895ec2d7f6',
    criterion_id: '0285619c-cfc8-4858-bef6-74adc0aac055',
    number: 2,
    name: 'Le prestataire diffuse des indicateurs de résultats adaptés à la nature des prestations mises en œuvre et des publics accueillis.',
    level_expected: 'Donner une information chiffrée sur le niveau de performance et d’accomplissement de la prestation.',
    proof: 'Tous supports et outils d’information, rapports d’activités, bilans, résultats d’enquêtes, indicateurs de performance.

    Exemples d’indicateurs de résultats : taux de satisfaction des stagiaires, nombre de stagiaires, taux et causes des abandons, taux de retour des enquêtes, taux d’interruption en cours de prestation, taux de rupture des contrats d’alternance (apprentissage et professionnalisation), taux d’insertion dans l’emploi. Pour les CFA : ratio du nombre d’apprentis ayant obtenu la certification sur le nombre d’apprentis présents à l’examen.

    Pour les CBC : nombre de bénéficiaires en début et en fin d’accompagnement, taux de réalisation des entretiens de suivi à six mois, nature et nombre d’enquêtes-terrain réalisées par les bénéficiaires pour valider leur projet.

    Pour la VAE : nombre de candidats accompagnés, taux de réussite globale, taux de réussite sur les diplômes les plus demandés (validation totale, partielle, jusqu’au contrôle complémentaire), taux de satisfaction des clients.',
    requirement: 'CFA : les indicateurs de résultats obligatoires sont ceux cités à l’article L. 6111-8 du Code du travail.

    Ils sont calculés par les ministères chargés de la formation professionnelle et de l’éducation nationale et rendus publics. Le CFA informe de la mise à disposition de ces indicateurs sur le site de diffusion https://www.inserjeunes.education.gouv.fr/diffusion/ accueil.

    Nouveaux entrants : des indicateurs sont pré-identifiés au moment de l’audit initial et sont audités au moment de l’audit de surveillance.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une information insuffisamment détaillée.',
    glossary: 'Indicateurs de résultats : information chiffrée sur le niveau de performance et d’accomplissement de la prestation.'
  },
  {
    id: '65781e6b-275b-4720-a2a8-cf8088067b7b',
    criterion_id: '0285619c-cfc8-4858-bef6-74adc0aac055',
    number: 3,
    name: 'Lorsque le prestataire met en œuvre des prestations conduisant à une certification professionnelle, il informe sur les taux d’obtention des certifications préparées, les possibilités de valider un/ou des blocs de compétences, ainsi que sur les équivalences, passerelles, suites de parcours et les débouchés.',
    level_expected: 'Donner au public une information accessible, exhaustive et actualisée.',
    proof: 'Tous supports et outils d’information : plaquette, réseaux sociaux, sites internet, supports publicité, salons, supports de contractualisation, taux d’obtention d’une certification pour les formations certifiantes, trajectoires d’évolution des bénéficiaires à l’issue de la prestation insertion ou mobilité.',
    requirement: 'Nouveaux entrants : la communication sur les taux d’obtention des certifications est auditée lors de l’audit de surveillance.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une information partiellement accessible ou par l’absence ponctuelle et non répétitive de certains items (à l’exclusion du taux d’obtention de la certification) dans la communication du prestataire.',
    glossary: 'Certification professionnelle : Les certifications enregistrées au répertoire national des certifications professionnelles (RNCP) sont appelées « certifications professionnelles ». Elles permettent une validation des compétences et des connaissances acquises nécessaires à l’exercice d’activités professionnelles (article L. 6113-1 du Code du travail).'
  },
  {
    id: 'aa49d079-5997-4da1-8f09-830d1d7f79ab',
    criterion_id: 'd0127e8f-d121-4a02-a280-275e1e060573',
    number: 4,
    name: 'Le prestataire analyse le besoin du bénéficiaire en lien avec l’entreprise et/ou le financeur concerné(s).',
    level_expected: 'Démontrer comment le besoin du bénéficiaire est analysé en fonction de la finalité de la prestation.',
    proof: 'Tout support synthétisant les besoins identifiés du bénéficiaire ou d’un groupe de bénéficiaires (grilles d’analyse, diagnostics préalables, dossiers d’admission, comptes rendus d’entretiens, critères de détermination de l’opportunité et de la faisabilité de la prestation).

    Pour la VAE : contractualisation de l’accompagnement décrivant notamment la méthode, les modalités individuelles et collectives, ainsi que l’échéancier de la mise en œuvre.

    NB : Dans le cas où le prestataire n’est pas responsable de l’analyse du besoin du bénéficiaire, il démontre qu’il en tient compte dans la conception et l’exécution de sa prestation.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    requirement: 'Dans le cas où le prestataire accueille un public en situation de handicap : le prestataire démontre qu’il prend en compte les situations de handicap et les besoins en compensation (pédagogie, matériel, moyens techniques, humains...).

    CFA ou alternance : le prestataire démontre que cette analyse est prévue en amont du processus de contractualisation alternant/entreprise.

    CBC : l’outil utilisé dans le cadre de la phase préliminaire (par exemple la grille d’analyse partagée de la situation APS) doit déboucher sur la coconstruction d’un programme personnalisé avec le bénéficiaire.',
    glossary: 'Bénéficiaire : personne à qui la prestation est dispensée.'
  },
  {
    id: '2bcf2adc-deb9-412f-9c10-0a11592ca643',
    criterion_id: 'd0127e8f-d121-4a02-a280-275e1e060573',
    number: 5,
    name: 'Le prestataire définit les objectifs opérationnels et évaluables de la prestation.',
    level_expected: 'Démontrer que les objectifs sont opérationnels et évaluables.',
    proof: 'Tous supports et outils d’analyse, existence d’indicateurs de suivi et de résultats, supports de contractualisation.

    Pour la VAE : fiches de travail formalisant le cadre de travail avec le bénéficiaire, programme de travail avec durées prévues, entretiens avec accompagnateurs.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    requirement: 'CFA ou alternance : ces objectifs doivent être exprimés en compétences et/ou capacités professionnelles à acquérir et/ou en certifications visées.

    CBC : il existe des outils et grilles utilisés pour codéfinir les objectifs en phase préliminaire et des documents de synthèse. Il peut s’agir d’objectifs en lien avec le développement des compétences à s’orienter.

    VAE : l’accompagnement est contractualisé et énonce les engagements respectifs du bénéficiaire et de l’accompagnateur.'
  },
  {
    id: 'fb752ef0-36d3-487d-865f-3633f5378a66',
    criterion_id: 'd0127e8f-d121-4a02-a280-275e1e060573',
    number: 6,
    name: 'Le prestataire établit les contenus et les modalités de mise en œuvre de la prestation, adaptés aux objectifs définis et aux publics bénéficiaires.',
    level_expected: 'Démontrer que les contenus et modalités de mise en œuvre des prestations sont adaptés aux objectifs définis en fonction des bénéficiaires.',
    proof: 'Parcours, déroulés et séquences, grilles et modalités d’évaluation, modalités techniques et pédagogiques d’accompagnement : en présentiel, à distance ou en mixte (blended learning, synchrone ou asynchrone). Supports de contractualisation, de réalisation, modalités de mise en œuvre, référentiels des diplômes, guide pratique du déroulé de la prestation, avec la durée et le calendrier.

    Pour la VAE et les formations certifiantes : ateliers collectifs d’explicitation de l’expérience.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    glossary: 'Blended learning : combinaison de séquences de formation en ligne (e-learning) et en présentiel.

    Synchrone ou asynchrone : dans une formation synchrone, l’échange avec les autres apprenants ou avec les tuteurs s’effectue en temps réel, par chat, par web-conférence ou par visioconférence. Les formations synchrones permettent également de partager des applications et d’interagir sur celles-ci au moment où le tuteur leur donne la main sur le document partagé. Dans une formation asynchrone, l’échange avec les autres apprenants ou avec les tuteurs s’effectue via des modes de communication ne nécessitant pas de connexion simultanée. Il peut s’agir de forums de discussion ou bien encore de l’échange de mails.'
  },
  {
    id: '56370de4-fd54-407a-a3c5-a7fce07a0463',
    criterion_id: 'd0127e8f-d121-4a02-a280-275e1e060573',
    number: 7,
    name: 'Lorsque le prestataire met en œuvre des prestations conduisant à une certification professionnelle, il s’assure de l’adéquation du ou des contenus de la prestation aux exigences de la certification visée.',
    level_expected: 'Démontrer l’adéquation du contenu aux compétences ciblées et aux épreuves d’évaluation de la certification.',
    proof: 'Tableau croisé du contenu de la formation et du référentiel de compétences.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.'
  },
  {
    id: '11d73ed4-ecf1-403b-9ea2-b8145cbf941a',
    criterion_id: 'd0127e8f-d121-4a02-a280-275e1e060573',
    number: 8,
    name: 'Le prestataire détermine les procédures de positionnement et d’évaluation des acquis à l’entrée de la prestation.',
    level_expected: 'Démontrer la mise en œuvre des procédures de positionnement et d’évaluation des acquis à l’entrée de la prestation adaptée aux publics et modalités de formations.',
    proof: 'Diagnostic préalable, entretien, évaluation des acquis à l’entrée (quizz, QCM, exercices, mise en situation, test), outils de mesure des écarts en termes de compétences à acquérir ou à faire valider, procédures de positionnement et/ou conditions d’accès.

    NB : S’il n’y a pas de prérequis, cette information est communiquée.

    Le positionnement peut se limiter à la prise en compte des diplômes, certificats ou titres exigés, expérience si le prestataire justifie de leur adaptation.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par un dispositif existant mais incomplet.',
    glossary: 'Procédures de positionnement : procédé permettant d’identifier ce qui est acquis en termes de compétences et connaissances et ce qui doit faire l’objet d’un apprentissage.'
  },
  {
    id: 'c0616f05-3dda-4a47-b0db-d716c9b19105',
    criterion_id: '50168ad5-ef10-43cd-a76e-050278e99705',
    number: 9,
    name: 'Le prestataire informe les publics bénéficiaires des conditions de déroulement de la prestation.',
    level_expected: 'Les modalités d’accueil et les conditions de déroulement de la prestation sont formalisées et diffusées.',
    proof: 'Règlement intérieur, livret d’accueil, convocation, conditions générales d’utilisation (CGU), noms des référents pédagogiques et administratifs, organigramme, aspects périphériques à la formation (hébergement, restauration, transport, rémunération...), modalités d’accès des personnes en situation de handicap.

    NB : Les documents peuvent être adressés aux bénéficiaires par mail ou par courrier. Ils peuvent aussi être disponibles sur le site internet ou affichés dans les locaux et les bénéficiaires doivent en être informés.

    Pour le public mineur, l’information doit être transmises également aux responsables légaux.

    Si les prestations se déroulent en entreprise, le règlement intérieur de l’entreprise est applicable concernant les mesures de santé et de sécurité.',
    requirement: 'CBC : l’obligation d’information sur les engagements déontologiques (respect du consentement, confidentialité, neutralité) est mise en œuvre.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une information incomplète.'
  },
  {
    id: 'c728314d-2426-4d69-b4d6-dad1c2a3a47f',
    criterion_id: '50168ad5-ef10-43cd-a76e-050278e99705',
    number: 10,
    name: 'Le prestataire met en œuvre et adapte la prestation, l’accompagnement et le suivi aux publics bénéficiaires.',
    level_expected: 'La prestation est adaptée aux situations et profils des bénéficiaires : contenus (outils et méthodes), accompagnement, suivi (durées, emplois du temps, adaptation des rythmes).',
    proof: 'Durées et contenus des prestations, emplois du temps, groupes de niveaux, entretiens, fonction dédiée (référent pédagogique), livret de suivi pédagogique (centre/entreprise), séquences d’accompagnements et/ou de médiation. Pour les PSH, liste de structures / personnes ressources (réactualisée régulièrement) susceptibles d’aider à aménager les parcours.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    requirement: 'CFA : le prestataire met en œuvre les dispositions de la loi relative aux obligations des CFA pour l’accompagnement des apprentis (article L. 6231-2).

    VAE : le prestataire met en œuvre les phases individuelles et/ou collectives et adapte la durée et les modalités d’accompagnement en fonction du bénéficiaire.

    CBC : la convention de prestation précise la durée, le coût, le planning prévisionnel, la description des trois étapes du bilan de compétences, la description des moyens, outils, méthodes, modalités pédagogiques et postures utilisés.'
  },
  {
    id: '67f2a17b-51ad-4fd0-b157-29f16badf6f1',
    criterion_id: '50168ad5-ef10-43cd-a76e-050278e99705',
    number: 11,
    name: 'Le prestataire évalue l’atteinte par les publics bénéficiaires des objectifs de la prestation.',
    level_expected: 'Démontrer qu’un processus d’évaluation existe, est formalisé et mis en œuvre. Il permet d’apprécier l’atteinte des objectifs.',
    proof: 'Outils d’évaluation des acquis en cours et en fin de prestation (à chaud et à froid), outils d’auto-évaluation mis à la disposition des bénéficiaires, bilans intermédiaires, comptes-rendus, taux de réussite aux certifications professionnelles et concours, livret de compétences, preuve de délivrance de la certification.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    requirement: 'VAE : dossier de suivi du candidat permettant d’apprécier la progression du bénéficiaire tout au long de la prestation au regard des objectifs.

    Nouveaux entrants : un processus d’évaluation existe et est formalisé. Sa mise en œuvre sera auditée lors de l’audit de surveillance.'
  },
  {
    id: '60ff9d8e-8b26-4ad2-82d6-1428f07e2312',
    criterion_id: '50168ad5-ef10-43cd-a76e-050278e99705',
    number: 12,
    name: 'Le prestataire décrit et met en œuvre les mesures pour favoriser l’engagement des bénéficiaires et prévenir les ruptures de parcours.',
    level_expected: 'Démontrer que des mesures formalisées existent et sont mises en œuvre.',
    proof: 'Procédure de gestion des abandons et de relance systématique, listing de relances téléphoniques, carnet de rendez-vous, outils et méthodes favorisant l’implication du bénéficiaire (documents co-construits, espaces partagés), enquêtes terrain, plateforme pédagogique, variété des modalités pédagogiques.

    Pour les prestataires délivrant des formations en alternance : contacts/visites avec l’entreprise, organisation de rencontres avec les formateurs, les tuteurs/ maîtres d’apprentissage, le cas échéant les familles, modalités d’accompagnement pour détecter, prévenir et empêcher les risques d’abandon, de décrochage et/ou proposition de solutions alternatives : accompagnement spécifique (social, pédagogique), service de médiation par les Chambres.',
    requirement: 'CFA : le prestataire apporte en lien avec le Service Public de l’Emploi (article L. 6231-2 du Code du travail), un accompagnement afin notamment :
    • de prévenir ou résoudre les difficultés d’ordre social et matériel susceptibles de mettre en péril le déroulement du contrat d’apprentissage ;
    • d’orienter les apprentis ayant interrompu leur formation ou n’ayant pas obtenu leur certification vers des organismes susceptibles de les accompagner dans la définition d’un projet de poursuite de formation ;
    • d’aider activement les apprentis dans la recherche d’une autre entreprise si besoin.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une mise en œuvre partielle des mesures définies.'
  },
  {
    id: '3034fdc7-cc65-422c-bb64-5f881390f49e',
    criterion_id: '50168ad5-ef10-43cd-a76e-050278e99705',
    number: 13,
    name: 'Pour les formations en alternance, le prestataire, en lien avec l’entreprise, anticipe avec l’apprenant les missions confiées, à court, moyen et long terme, et assure la coordination et la progressivité des apprentissages réalisés en centre de formation et en entreprise.',
    level_expected: 'Démontrer qu’un processus formalisé d’articulation des apprentissages en centre et en entreprise est mis en œuvre.',
    proof: 'Tout outil de liaison entre l’entreprise, le bénéficiaire et le prestataire : carnet de suivi, preuves de dialogue entre prestataire et tuteurs pour l’adaptation, plannings, comptes rendus d’entretien ou de visite d’entreprise, tableau de bord dématérialisé.',
    requirement: 'Nouveaux entrants : un processus d’articulation des apprentissages est formalisé pour les deux lieux de formation : en centre de formation et en entreprise. La mise en œuvre sera auditée lors de l’audit de surveillance.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une mise en œuvre partielle des processus définis.',
    glossary: 'Alternance : modalité de formation qui se caractérise par l’acquisition organisée et progressive de compétences dans le cadre d’activités formatives et professionnelles. Celles-ci se déroulent en alternance en centre de formation (ou à distance), et en entreprise (ou dans une structure d’insertion par l’activité économique).

    Les contrats « en alternance » sont des contrats de travail constitués de périodes de formation pratique en entreprise et de périodes de formation théorique en établissement de formation.'
  },
  {
    id: '472e0c7c-55e0-49af-a6ae-bdb606640042',
    criterion_id: '50168ad5-ef10-43cd-a76e-050278e99705',
    number: 14,
    name: 'Le prestataire met en œuvre un accompagnement socio-professionnel, éducatif et relatif à l’exercice de la citoyenneté.',
    level_expected: 'Démontrer que l’accompagnement de l’apprenant est formalisé et mis en œuvre par la mise en place de projets spécifiques.',
    proof: 'Mise en place de projets spécifiques d’activités sportives, ateliers culturels, éducation aux écrans, culture à l’exercice de la citoyenneté, dispositifs d’aides financières, listes des intervenants sociaux, dispositif d’accompagnement des apprenants dans le centre (restauration, foyer, internat).',
    requirement: 'Nouveaux entrants : l’accompagnement est formalisé. Sa mise en œuvre sera auditée lors de l’audit de surveillance.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    glossary: 'L’accompagnement socio-professionnel et éducatif : favorise l’apprentissage et l’accès à l’emploi des personnes. Il peut s’agir par exemple :
    • de la réalisation d’un bilan (formation, compétences, expérience professionnelle) ;
    • de l’identification et du suivi des problématiques sociales individuelles ;
    • de l’orientation vers les organismes compétents (santé, logement, demande d’allocations diverses, problèmes de garde d’enfants...) ;
    • de l’aide aux démarches administratives ;
    • de l’élaboration d’un projet professionnel et d’un parcours d’insertion professionnelle ;
    • d’actions de soutien psychologique et matériel en dehors du temps de travail ;
    • d’actions relatives à la mobilité professionnelle (obtention du permis de conduire...) ;
    • d’interventions favorisant le développement personnel (accès à la culture et aux loisirs) ;
    • de l’apprentissage de la citoyenneté.'
  },
  {
    id: '5d7954b8-79f7-4ff0-a2bc-efe10dba729b',
    criterion_id: '50168ad5-ef10-43cd-a76e-050278e99705',
    number: 15,
    name: 'Le prestataire informe les apprentis de leurs droits et devoirs en tant qu’apprentis et salariés ainsi que des règles applicables en matière de santé et de sécurité en milieu professionnel.',
    level_expected: 'Démontrer que les apprentis sont informés des droits et devoirs des salariés /apprentis et sur les règles applicables en matière de santé et de sécurité en milieu professionnel.',
    proof: 'Réglement intérieur, supports d’informations, supports de contractualisation, compte-rendu de réunions d’informations collectives, livret d’accueil.',
    non_conformity: 'Dansl’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.'
  },
  {
    id: '6a0eb50b-725d-44c7-8e05-57eb8cf2c8aa',
    criterion_id: '50168ad5-ef10-43cd-a76e-050278e99705',
    number: 16,
    name: 'Lorsque le prestataire met en œuvre des formations conduisant à une certification professionnelle, il s’assure que les conditions de présentation des bénéficiaires à la certification respectent les exigences formelles de l’autorité de certification.',
    level_expected: 'Le prestataire respecte les exigences formelles de l’autorité de certification lorsqu’il présente des candidats à la certification qu’il propose.',
    proof: 'Procès-verbal des sessions d’examen, livret d’évaluations réalisées en cours de formation, attestations de réussite ou de suivi à des formations réglementaires obligatoires pour obtenir la certification visée.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    requirement: 'VAE : le prestataire démontre qu’il a demandé au certificateur les conditions de présentation aux certifications et les calendriers de jury.'
  },
  {
    id: 'ad070df9-fb5e-48c7-85a6-f17a7d357e25',
    criterion_id: '4207cf14-b32f-4ee3-a0e9-5a472801e4d3',
    number: 17,
    name: 'Le prestataire met à disposition ou s’assure de la mise à disposition des moyens humains et techniques adaptés et d’un environnement approprié (conditions, locaux, équipements, plateaux techniques...).',
    level_expected: 'Démontrer que les locaux, les équipements, les moyens humains sont en adéquation avec la ou les prestation(s).',
    proof: 'Bail ou contrat de location précisant la conformité des locaux pour l’accueil du public, Document unique d’évaluation des risques professionnels, matériel adéquat (vidéo projecteur, paper-board, ordinateur, équipements spécifiques, chantiers pédagogiques, salles de langues, plateaux techniques, plateformes LMS, aides à la connexion à distance, planning d’intervention, espace documentaire, plateforme pédagogique), CV, supports méthodologiques, convention de formation (formation en intra notamment), contrats de prestations.',
    requirement: 'CBC : mise à disposition des moyens dédiés à l’activité. Un environnement garantissant la discrétion et la confidentialité des échanges est prévu. Le cas échéant, l’habilitation des personnes devant faire passerlestestsestprécisée.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par un défaut dans les moyens ponctuel et non répétitif.'
  },
  {
    id: '4599987c-d653-44ad-8de9-636b72b6440c',
    criterion_id: '4207cf14-b32f-4ee3-a0e9-5a472801e4d3',
    number: 18,
    name: 'Le prestataire mobilise et coordonne les différents intervenants internes et/ou externes (pédagogiques, administratifs, logistiques, commerciaux...).',
    level_expected: 'Démontrer l’existence d’une coordination des fonctions nécessaires à la prestation.',
    proof: 'Organigramme fonctionnel avec les champs d’intervention (pédagogique, technique, commercial, social), liste des intervenants/contributeurs, contrats de travail, de prestations de service, fiches de poste, liste des référents pédagogiques, administratifs et handicap.

    NB : Un prestataire indépendant peut assurer seul les différentes fonctions.',
    requirement: 'VAE : les intervenants externes ne sont ni les certificateurs ni les financeurs.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par un défaut ponctuel de coordination.',
    glossary: 'Intervenants internes : dirigeants et salariés intervenant dans le cadre d’un contrat de travail (dont formateurs occasionnels).

    Intervenants externes : tous les sous-traitants intervenant dans le cadre d’un contrat de prestation de service.'
  },
  {
    id: 'd69cef52-4e75-409c-8d8b-7766ac90321c',
    criterion_id: '4207cf14-b32f-4ee3-a0e9-5a472801e4d3',
    number: 19,
    name: 'Le prestataire met à disposition du bénéficiaire des ressources pédagogiques et permet à celui-ci de se les approprier.',
    level_expected: 'Démontrer que les ressources pédagogiques existent, sont actualisées et disponibles et démontrer que des dispositions sont mises en place afin de permettre aux bénéficiaires de se les approprier.',
    proof: 'Ressources pédagogiques mises à disposition des bénéficiaires : supports de cours/d’explicitation des compétences, vidéos, fiches pratiques, outils d’exploration du monde du travail et projections professionnelles, liste des ressources documentaires en lien avec les domaines ciblés par la prestation dont dispose le prestataire (fiches RNCP...), typologie des ressources pédagogiques (internet, abonnements revues spécialisées, centre de ressources), modalités d’accès aux ressources pour les bénéficiaires, les équipes pédagogiques, modalités activées pour faciliter l’utilisation et l’appropriation par les bénéficiaires des ressources (présentiel, à distance, espace partagé), dispositif de veille et d’actualisation des ressources pédagogiques. Pour les PSH, modalités d’accès ou supports spécifiques et capitalisation des aménagements mis en oeuvre.

    Pour les CBC : espace documentaire ou outils dématérialisés ou plateforme pédagogique numérique, données socio-économiques relatives au projet professionnel, modalités d’appui à l’exploration des hypothèses d’évolution professionnelle (supports, liste de personnes ressources, ateliers).',
    requirement: 'Nouveaux entrants : démontrer que les ressources pédagogiques sont prévues, et des dispositions seront mises en place afin de permettre aux bénéficiaires de se les approprier. La mise en œuvre sera auditée lors de l’audit de surveillance.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par un défaut ponctuel et non répétitif dans les ressources et les moyens mis à disposition.'
  },
  {
    id: '961639a6-4049-45ad-b1e0-f51017926458',
    criterion_id: '4207cf14-b32f-4ee3-a0e9-5a472801e4d3',
    number: 20,
    name: 'Le prestataire dispose d’un personnel dédié à l’appui à la mobilité nationale et internationale, d’un référent handicap et d’un conseil de perfectionnement.',
    level_expected: 'Le prestataire présente :
    la liste des membres du conseil de perfectionnement, le dernier compterendu et/ou procès-verbal ;
    la liste des personnes dédiées à la mobilité (nationale et internationale) ;
    le nom et le contact du référent handicap.',
    proof: 'Nom et qualité des membres du conseil de perfectionnement (dernier compte-rendu et/ou procès-verbal, preuve de constitution en cours du conseil de perfectionnement pour le nouveau CFA) ;
    nom et qualité des personnes dédiées à la mobilité (nationale et internationale) ;
    nom du référent handicap et procès-verbal de sa nomination.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.'
  },
  {
    id: '5f4cbf53-d044-4783-a7a7-ccaadb6cadb1',
    criterion_id: '79185ec5-4249-48ce-994f-6ca3750139e6',
    number: 21,
    name: 'Le prestataire détermine, mobilise et évalue les compétences des différents intervenants internes et/ou externes, adaptées aux prestations.',
    level_expected: 'Démontrer que les compétences requises pour réaliser les prestations ont été définies en amont et sont adaptées aux prestations.
    La maîtrise de ces compétences fait par ailleurs l’objet d’une évaluation par le prestataire.',
    proof: 'Analyse des besoins de compétences et modalités de recrutement, modalité d’intégration des personnels, entretiens professionnels, curriculum vitae des formateurs, formations initiales et continues des formateurs, sensibilisation des personnels à l’accueil du public en situation de handicap, processus d’accueil des nouveaux professionnels, échanges de pratiques, plan de développement des compétences, pluridisciplinarité des intervenants (par la composition des équipes ou la capacité de mobilisation de personnes ressources).

    NB : Cet indicateur concerne également les sous-traitants du prestataire.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    requirement: 'VAE : les accompagnateurs sont formés à l’analyse des référentiels métiers et certifications dont ils ont la charge et à la méthodologie d’accompagnement.'
  },
  {
    id: 'd4844442-7492-4417-b172-ea661e069dfc',
    criterion_id: '79185ec5-4249-48ce-994f-6ca3750139e6',
    number: 22,
    name: 'Le prestataire entretient et développe les compétences de ses salariés, adaptées aux prestations qu’il délivre.',
    level_expected: 'Démontrer l’existence d’un plan de développement des compétences pour l’ensemble de son personnel.',
    proof: 'Mobilisation de différents leviers de formation/professionnalisation, qualification des personnels, recherche-action, plan de développement des compétences, entretien professionnel, communauté de pairs, groupe d’analyse et d’échange de pratiques, diffusion de documents d’information sur les possibilités de formation et de qualification tout au long de la vie (CPF, VAE, etc.).

    NB : Les prestataires indépendants démontrent leur démarche de formation continue.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    requirement: 'Nouveaux entrants : cet indicateur sera audité lors de l’audit de surveillance.'
  },
  {
    id: 'cf646004-4064-4907-8859-daf73c9196bf',
    criterion_id: 'b87aa3c2-37d6-4576-ae2c-e5ea2a74e7e4',
    number: 23,
    name: 'Le prestataire réalise une veille légale et réglementaire sur le champ de la formation professionnelle et en exploite les enseignements.',
    level_expected: 'Démontrer la mise en place d’une veille légale et réglementaire et son exploitation.',
    proof: 'Abonnements, adhésions, participation aux salons professionnels, conférences, groupes normatifs, actualisation des supports d’information (publicité) ou de contractualisation, des dispositifs mobilisés (règles CPF) en fonction des évolutions juridiques, veille réglementaire en matière de handicap.

    Pour la VAE : documentation à jour sur le cadre légal du droit individuel à la VAE et de ses modalités de financement.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une exploitation partielle de la veille mise en place.'
  },
  {
    id: '94c4bf4c-ca0a-4676-a9bf-22a4f743a4d7',
    criterion_id: 'b87aa3c2-37d6-4576-ae2c-e5ea2a74e7e4',
    number: 24,
    name: 'Le prestataire réalise une veille sur les évolutions des compétences, des métiers et des emplois dans ses secteurs d’intervention et en exploite les enseignements.',
    level_expected: 'Démontrer la mise en place d’une veille sur les thèmes de l’indicateur et son impact éventuel sur les prestations.',
    proof: 'Veille économique et documents y afférents, participations à des conférences, colloques, salon, adhésion à un réseau professionnel (syndicat, fédération, forums), abonnements à des revues professionnelles. Diffusion des éléments issus de la veille au personnel du prestataire, évolutions apportées au contenu des prestations proposées.',
    requirement: 'Nouveaux entrants : Démontrer la mise en place d’une veille économique. L’impact éventuel sera audité lors de l’audit de surveillance.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une exploitation partielle de la veille mise en place.'
  },
  {
    id: '05413135-8136-47a5-88f9-16f13167ff2d',
    criterion_id: 'b87aa3c2-37d6-4576-ae2c-e5ea2a74e7e4',
    number: 25,
    name: 'Le prestataire réalise une veille sur les innovations pédagogiques et technologiques permettant une évolution de ses prestations et en exploite les enseignements.',
    level_expected: 'Démontrer la mise en place d’une veille sur les thèmes de l’indicateur et son impact éventuel sur les prestations.',
    proof: 'Veille économique et documents y afférents, participations à des conférences, colloques, salons, groupes de réflexions et d’analyse de pratiques, adhésion à un réseau professionnel (syndicat, fédération, forums), abonnements à des revues professionnelles. Diffusion des éléments issus de la veille au personnel du prestataire, évolutions apportées au contenu des prestations proposées. Pour les organismes qui accueillent des personnes en situation de handicap, participation à des conférences thématiques, colloques, salons, groupes de réflexions et d’analyse de pratiques en matière d’innovations pédagogiques et technologiques pour le public visé.',
    requirement: 'Nouveaux entrants : démontrer la mise en place d’une veille pédagogique et technologique. L’indicateur sera audité lors de l’audit de surveillance.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une exploitation partielle de la veille mise en place.'
  },
  {
    id: '3a5e11e4-d82d-4331-aa51-7666d80604df',
    criterion_id: 'b87aa3c2-37d6-4576-ae2c-e5ea2a74e7e4',
    number: 26,
    name: 'Le prestataire mobilise les expertises, outils et réseaux nécessaires pour accueillir, accompagner/former ou orienter les publics en situation de handicap.',
    level_expected: 'Démontrer la mise en place d’un réseau de partenaires/experts/acteurs du champ du handicap, mobilisable par les personnels et dans le cas d’accueil de personnes en situation de handicap, préciser les mesures spécifiques mises en œuvre.',
    proof: 'Liste des partenaires du territoire susceptibles d’aider le prestataire dans la prise en compte des PSH, dont les partenaires spécialisés intervenants pour le compte de l’Agefiph et du Fiphfp.

    Participation aux instances et manifestation des partenaires, compte-rendu de rencontres. Compétences et connaissances du référent handicap.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    requirement: 'Nouveaux entrants : démontrer la mise en place d’un réseau de partenaires/experts/acteurs du champ du handicap.',
    glossary: 'Agefiph : Association de gestion du fonds pour l’insertion des personnes handicapées (www.agefiph.fr).

    Fiphfp : Fonds pour l’insertion des PSH dans la fonction publique.'
  },
  {
    id: '5cbf65ab-1ad0-44c2-bf6f-e3098d734b77',
    criterion_id: 'b87aa3c2-37d6-4576-ae2c-e5ea2a74e7e4',
    number: 27,
    name: 'Lorsque le prestataire fait appel à la sous-traitance ou au portage salarial, il s’assure du respect de la conformité au présent référentiel.',
    level_expected: 'Démontrer les dispositions mises en place pour vérifier le respect de la conformité au présent référentiel par le sous-traitant ou le salarié porté.',
    proof: 'Contrats de prestations de service, tous les éléments qui permettent de démontrer les modalités de sélection et de pilotage des sous-traitants (process de sélection, justificatifs présentés par les sous-traitants et les salariés portés, animation qualité dédiée, charte). NB : Cela ne signifie pas une obligation de certification des sous-traitants : la responsabilité de la qualité appartient au donneur d’ordre, charge à ce dernier de mettre en place les modalités qui assurent la chaîne de la qualité y compris avec les sous-traitants.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.'
  },
  {
    id: '2fa64872-89d3-47c9-841c-630fc10f2d77',
    criterion_id: 'b87aa3c2-37d6-4576-ae2c-e5ea2a74e7e4',
    number: 28,
    name: 'Lorsque les prestations dispensées au bénéficiaire comprennent des périodes de formation en situation de travail, le prestataire mobilise son réseau de partenaires socio-économiques pour coconstruire l’ingénierie de formation et favoriser l’accueil en entreprise.',
    level_expected: 'Démontrer l’existence d’un réseau de partenaires socio-économiques mobilisé tout au long de la prestation.',
    proof: 'Comités de pilotage, comptes rendus de réunions, liste des entreprises partenaires, conventions de partenariats, contacts réseau SPE, livret alternance, informations sur les partenariats. NB : Cet indicateur vise tous les prestataires de formation, y compris les CFA, dans leur capacité à mobiliser un réseau de partenaires lors des périodes de formation en situation de travail. Pour les apprentis, ces périodes correspondent par définition à la formation pratique en entreprise ; pour les salariés en contrat de professionnalisation, il peut s’agir des périodes d’acquisition d’un savoir-faire en entreprise',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par un défaut ponctuel et non répétitif dans la mobilisation des partenaires.',
    glossary: 'Partenaires socio-économiques : entreprises (tous statuts) ; chambres consulaires : CCI, agriculture et CMA ; établissement public de coopération intercommunale (EPCI), communautés d’agglomération, communautés de communes ; structures de l’insertion par l’activité économique : ateliers et chantiers d’insertion (ACI), association intermédiaire (AI), entreprise d’insertion (EI) et entreprise de travail temporaire d’insertion (ETTI) ; service public de l’emploi, service public de l’orientation ; branches professionnelles ; centres sociaux ; organismes paritaires, association Transition Pro (CPIR), opérateurs CEP ; services de l’État, etc.'
  },
  {
    id: '3c2e2f5d-bd5c-4730-bfb3-8e9ccc93e687',
    criterion_id: 'b87aa3c2-37d6-4576-ae2c-e5ea2a74e7e4',
    number: 29,
    name: 'Le prestataire développe des actions qui concourent à l’insertion professionnelle ou la poursuite d’étude par la voie de l’apprentissage ou par toute autre voie permettant de développer leurs connaissances et leurs compétences.',
    level_expected: 'Démontrer l’existence d’actions qui concourent à l’insertion professionnelle ou la poursuite d’études.',
    proof: 'Actions visant à favoriser l’insertion professionnelle des apprenants (salon d’orientation, visite d’entreprise, atelier CV/lettre de motivation, aide à la recherche d’emploi, réseau d’anciens élèves), actions de promotion de la poursuite d’étude, partenariats avec des acteurs de l’insertion et de l’emploi et avec le monde professionnel.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.'
  },
  {
    id: 'c0d8a5ed-584d-4e78-8b1e-88d0efcb26a5',
    criterion_id: 'fcd31ee6-a512-4e1a-9ff2-6f67b5c3d61d',
    number: 30,
    name: 'Le prestataire recueille les appréciations des parties prenantes : bénéficiaires, financeurs, équipes pédagogiques et entreprises concernées.',
    level_expected: 'Démontrer la mise en place d’un système de collecte des appréciations à une fréquence pertinente, incluant des dispositifs de relance et permettant une libre expression.',
    proof: 'Enquête de satisfaction, questionnaire, compte-rendu d’entretiens, évaluation à chaud et/ou à froid, analyse et traitement des appréciations formulées par les parties prenantes. Pour les CBC : questionnaire d’évaluation à l’issue du bilan et à 6 mois. NB : Les modalités de recueil selon la partie prenante peuvent être différentes. Les évaluations des acquis ne sont pas un élément de preuve probant pour cet indicateur.',
    non_conformity: 'Dans l’échantillon audité, une non-conformité mineure est caractérisée par une mise en œuvre partielle des mesures définies.'
  },
  {
    id: '87ef7ca5-fcd8-40d8-bc96-7ecbed4bb3c9',
    criterion_id: 'fcd31ee6-a512-4e1a-9ff2-6f67b5c3d61d',
    number: 31,
    name: 'Le prestataire met en œuvre des modalités de traitement des difficultés rencontrées par les parties prenantes, des réclamations exprimées par ces dernières, des aléas survenus en cours de prestation.',
    level_expected: 'Démontrer la mise en place de modalités de traitement des aléas, difficultés et réclamations.',
    proof: 'Description et mise en œuvre de ces modalités (accusé de réception des réclamations et réponses apportées aux réclamants), enquêtes de satisfaction, analyse et traitement des réclamations formulées par les stagiaires, système de médiation.',
    requirement: '',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.',
    glossary: 'Réclamation : action visant à faire respecter un droit, ou à demander une chose due, recueillie par écrit.'
  },
  {
    id: 'e664cea6-7dbb-4b0f-9407-ecd870cee7ac',
    criterion_id: 'fcd31ee6-a512-4e1a-9ff2-6f67b5c3d61d',
    number: 32,
    name: 'Le prestataire met en œuvre des mesures d’amélioration à partir de l’analyse des appréciations et des réclamations.',
    level_expected: 'Démontrer la mise en place d’une démarche d’amélioration continue.',
    proof: 'Identification et réflexion sur les causes d’abandon ou les motifs d’insatisfaction, plans d’actions d’amélioration, mise en œuvre d’actions spécifiques. Pour la VAE : partage des résultats de l’accompagnement (nombre de candidats en début et fin d’accompagnement, taux et causes d’abandon, taux de réussite à la VAE).',
    requirement: 'Nouveaux entrants : l’indicateur sera audité à l’audit de surveillance.',
    non_conformity: 'Dans l’échantillon audité, le non-respect (même partiel) de cet indicateur entraîne une non-conformité majeure.'
  }
]
