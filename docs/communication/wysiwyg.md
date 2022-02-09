# WYSIWYG

## Quels enjeux ?

Permettre l'édition, mais limiter les options graphiques (ni couleurs, ni tailles, ni typos).

Fonctionnalités :
- intégration d'images dans le corps du texte, en gardant la trace du blob active storage, et en les intégrant dans la liste des dépendances.
- intégration de vidéos.
- intégration d'autres formats (Tweets...).

## Solutions techniques

### ActionText

Avantages :
- active storage intégré
- Trix intégré

Inconvénients :
- Pas de modèle (polymorphic)

### Trix

Avantages :
- intégré à ActionText
- très limité

Inconvénients :
- très limité (target blank, 1 seul niveau de titre, pas d'embed, pas de code source)
- pas extensible

### Summernote

Avantages :
- vaste
- extensible

Inconvénients :
- dépendance jQuery
- pas intégré à ActionText
- moyennement robuste quand on le torture

### Page builder custom

Avantages :
- puissant
- souple

Inconvénients :
- compliqué à construire et maintenir
- compliqué à utiliser


## Benchmark

[Refinery](https://www.refinerycms.com/)


[Spina](https://spinacms.com/)


[Alchemy CMS](https://alchemy-cms.com/)


[Locomotive CMS](https://www.locomotivecms.com/)
