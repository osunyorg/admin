# Blocks

Blocs de contenus ajoutés à un objet (page, post, program...),
avec des templates (organigramme, partenaires...).

Il faut lister les dépendances des blocs et les ajouter à l'objet about.

## Dev

### Model

```
communication/website/Block
- university:references
- about:references (polymorphic)
- template:integer (enum)
- position:integer
- data:jsonb
```

Pour commencer, les valeurs de l'enum seront :
- 100, organization_chart
- 200, partners

### Partial about
Un partial que l'on peut ajouter à un show d'objet, avec :
- la liste des blocs utilisés (avec boutons show et edit)
- la possibilité de les ordonner (position)
- un bouton pour ajouter un bloc

```
views/admin/communication/blocks/_list.html.erb
```

### Show
Le show du bloc utilise le partial de son template
```
views/admin/communication/blocks/templates/partners/_show.html.erb
```

### Edit
L'edit du bloc utilise le partial de son template
```
views/admin/communication/blocks/templates/partners/_edit.html.erb
```

### Concern
Tous les objets ayant des blocs utilisent le concern `WithBlocks`, qui ajoute la méthode `blocks` (la liste des blocs, dans l'ordre).

### Export statique
Les blocs sont exportés dans le frontmatter grâce au partial
```
views/admin/communication/blocks/_static.html.erb
```
qui donne ce type de résultat
```
blocks:
  - template: partners
    data:
      - name: Partner 1
        url: https://partner1.com
        logo: "e09f3794-44e5-4b51-be02-0e384616e791"
```
Les générateurs de chaque type suivent l'organisation :
```
views/admin/communication/blocks/templates/partners/_static.html.erb
```
Attention, il faut 6 espaces pour respecter l'indentation du front-matter :
```
      - name: Partner 1
        url: https://partner1.com
        logo: "e09f3794-44e5-4b51-be02-0e384616e791"
```

### Dépendances

Il faut créer une classe pour chaque template, avec le nom au singulier (partners devient partner.rb, et la class Partner) :

```
models/communication/block/partner.rb
```
avec une structure de type :
```
class Communication::Block::Partner < Communication::Block::Template
  def git_dependencies
    ...
  end
end
```

## Pour créer un bloc

1. Déclarer le template dans l'enum du modèle block
2. Créer l'edit, le show et le static dans la vue du template
3. Créer la classe du template pour gérer les dépendances
4. Créer la vignette dans les images
5. Ecrire les locales fr et en
