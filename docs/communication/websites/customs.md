# Customs

Au-delà des pages et des actualités, les sites ont souvent besoin d'objets spécifiques, au cas par cas.
Le site https://www.osuny.org/ présente des fonctionnalités, avec un statut.
Le site https://cyberneticproject.eu/ présente des fiches techniques, avec des synonymes, des téléchargements, un récapitulatif, des références bibliographiques...


Afin de permettre cette souplesse, nous utilisons des types personnalisés (custom types).
Le type définit une nouvelle sorte d'objets (ex: feature, technical_sheet...).
Chaque type a des propriétés (title, description, summary, status, references...), qui génèrent un formulaire à la volée.
Le type s'ajoute au menu du site, et permet de créer des éléments.
Les éléments s'exportent en statique en utilisant la structure définie par les propriétés.

## Modèles

communication/website/custom/Type
- university:references
- website:references
- name:string
- identifier:string
- position:integer
- order:boolean
- tree:boolean
- date:boolean


Si order est true, les éléments de ce type peuvent être classés par position (js sortable).
Si tree est true, les éléments peuvent être organisés en arbre, avec des parents et des enfants.
Si date est true, les élément peuvent être publiés à une date donnée.


communication/website/custom/type/Property
- university:references
- website:references
- type:references
- name:string
- identifier:string
- kind:integer (enum)
- position


communication/website/custom/Element
- university:references
- website:references
- type:references
- name:string
- slug:string
- published:boolean
- published_at:datetime
- parent:references
- position:integer
- data:jsonb
