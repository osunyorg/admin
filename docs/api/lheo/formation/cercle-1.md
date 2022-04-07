# Formation - Cercle 1

http://lheo.gouv.fr/2.3/cercle1.html

## Informations

- [ ] Domaine de la formation (NSF, FORMACODE, ROME)
  - [ ] Code FORMACODE
  - [ ] Code NSF
  - [ ] Code ROME
- [x] Intitulé de la formation
- [ ] Organisme de formation responsable
  - [x] Nom de l’organisme de formation responsable
  - [ ] Numéro de déclaration d’activité
  - [ ] Numéro SIRET de l’organisme de formation
  - [ ] Raison sociale de l’organisme
  - [ ] Coordonnées de l’organisme
  - [ ] Contact avec l’organisme
- [x] Objectif de formation
- [x] Résultats attendus de la formation
- [x] Contenu de la formation
- [x] Formation certifiante
- [ ] Action de formation
  - [ ] Rythme de la formation
  - [ ] Niveau à l’entrée en formation obligatoire
  - [ ] Modalités de l’alternance
  - [ ] Formation présentielle ou à distance
  - [ ] Conditions spécifiques et prérequis
  - [ ] Prise en charge des frais de formation possible
  - [ ] Modalités d’entrées/sorties
  - [ ] Session de formation
    - [ ] Période (format ISO AAAAMMJJ)
      - [ ] Début
      - [ ] Fin
    - [ ] Adresse d’inscription
  - [ ] Code de public visé
- [ ] Contact de l’offre de formation
- [ ] Type de parcours de formation
- [ ] Niveau à l’entrée en formation

## XML

```xml
<formation>
  <!-- Domaine de la formation (NSF, FORMACODE, ROME) -->
  <domaine-formation> <!-- [1,1] -->
    <!-- Code FORMACODE -->
    <code-FORMACODE>...</code-FORMACODE> <!-- [0,5] -->
    <!-- Code NSF -->
    <code-NSF>...</code-NSF> <!-- [0,3] -->
    <!-- Code ROME -->
    <code-ROME>...</code-ROME> <!-- [0,5] -->
  </domaine-formation>
  <!-- Intitulé de la formation -->
  <intitule-formation>...</intitule-formation> <!-- [1,1] -->
  <!-- Objectif de formation -->
  <objectif-formation>...</objectif-formation> <!-- [1,1] -->
  <!-- Résultats attendus de la formation -->
  <resultats-attendus>...</resultats-attendus> <!-- [1,1] -->
  <!-- Contenu de la formation -->
  <contenu-formation>...</contenu-formation> <!-- [1,1] -->
  <!-- Formation certifiante -->
  <certifiante>...</certifiante> <!-- [1,1] -->
  <!-- Contact de l’offre de formation -->
  <contact-formation>...</contact-formation> <!-- [1,N] -->
  <!-- Type de parcours de formation -->
  <parcours-de-formation>...</parcours-de-formation> <!-- [1,1] -->
  <!-- Niveau à l’entrée en formation -->
  <code-niveau-entree>...</code-niveau-entree> <!-- [1,1] -->
  <!-- Action de formation -->
  <action> <!-- [1,N] -->
    <!-- Rythme de la formation -->
    <rythme-formation>...</rythme-formation> <!-- [1,1] -->
    <!-- Code de public visé -->
    <code-public-vise>...</code-public-vise> <!-- [1,10] -->
    <!-- Niveau à l’entrée en formation obligatoire -->
    <niveau-entree-obligatoire>...</niveau-entree-obligatoire> <!-- [1,1] -->
    <!-- Modalités de l’alternance -->
    <modalites-alternance>...</modalites-alternance> <!-- [1,1] -->
    <!-- Formation présentielle ou à distance -->
    <modalites-enseignement>...</modalites-enseignement> <!-- [1,1] -->
    <!-- Conditions spécifiques et prérequis -->
    <conditions-specifiques>...</conditions-specifiques> <!-- [1,1] -->
    <!-- Prise en charge des frais de formation possible -->
    <prise-en-charge-frais-possible>...</prise-en-charge-frais-possible> <!-- [1,1] -->
    <!-- Modalités d’entrées/sorties -->
    <modalites-entrees-sorties>...</modalites-entrees-sorties> <!-- [1,1] -->
    <!-- Session de formation -->
    <session> <!-- [1,N] -->
      <!-- Période -->
      <periode> <!-- [1,1] -->
        <!-- Début -->
        <debut>...</debut> <!-- [1,1] -->
        <!-- Fin -->
        <fin>...</fin> <!-- [1,1] -->
      </periode>
      <!-- Adresse d’inscription -->
      <adresse-inscription>...</adresse-inscription> <!-- [1,1] -->
    </session>
  </action>
  <!-- Organisme de formation responsable -->
  <organisme-formation-responsable> <!-- [1,1] -->
    <!-- Numéro de déclaration d’activité -->
    <numero-activite>...</numero-activite> <!-- [1,1] -->
    <!-- Numéro SIRET de l’organisme de formation -->
    <SIRET-organisme-formation>...</SIRET-organisme-formation> <!-- [1,1] -->
    <!-- Nom de l’organisme de formation responsable -->
    <nom-organisme>...</nom-organisme> <!-- [1,1] -->
    <!-- Raison sociale de l’organisme -->
    <raison-sociale>...</raison-sociale> <!-- [1,1] -->
    <!-- Coordonnées de l’organisme -->
    <coordonnees-organisme>...</coordonnees-organisme> <!-- [1,1] -->
    <!-- Contact avec l’organisme -->
    <contact-organisme>...</contact-organisme> <!-- [1,N] -->
  </organisme-formation-responsable>
</formation>
```

## Codes (domaine de formation)

https://www.data.gouv.fr/fr/datasets/repertoire-national-des-certifications-professionnelles-et-repertoire-specifique/
