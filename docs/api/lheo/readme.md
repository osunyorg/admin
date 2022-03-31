# API Lhéo

## Documentation

- http://lheo.gouv.fr/langage
- http://lheo.gouv.fr/2.3/lheo-exemple.xml
- http://lheo.gouv.fr/form/2419bc12/visualisation-xml

## Exemple (Osuny Bordeaux Montaigne)

https://bordeauxmontaigne.osuny.org/api/lheo

## Étapes

- Implémenter le 1er cercle
  Doc : http://lheo.gouv.fr/2.3/cercle1.html (à faire d'urgence)
- Implémenter le 2e cercle
  Doc : http://lheo.gouv.fr/2.3/cercle2.html

## Éléments manquants

- `<domaine-formation>`
  - Doc : http://lheo.gouv.fr/2.3/lheo/domaine-formation.html
  - Codes ROME (Amethys) : https://code.ametys.org/projects/ODF/repos/odf/browse/main/plugin-odf/doc/constants/code_rome.xml
  - Quel code utiliser ? Comment l'interfacer automatiquement ?
- `<certifiante>`
  - Doc : http://lheo.gouv.fr/2.3/lheo/certifiante.html
  - A priori les universités n'ont que des formations certifiantes, mais le privé pas forcément.
    Ajouter une checkbox ? Et en faire dépendre le champ "nom du diplôme" ?
