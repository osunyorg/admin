# Blocks

Blocs de contenus ajoutés à un objet (page, post, program...),
avec des templates (organigramme, partenaires...).

Il faut lister les dépendances des blocs et les ajouter à l'objet about.

## Dev

### Model

```
communication/website/Block
- university:references
- website:references
- about:references (polymorphic)
- template:integer (enum)
- data:jsonb
```

Pour commencer, les valeurs de l'enum seront :
- 100, organization_chart
- 200, partners

### Partial about
Un partial que l'on peut ajouter à un show d'objet, avec :
- la liste des blocs utilisés (avec boutons show et edit)
- la possibilité de les sort
- un bouton pour ajouter un bloc

```
views/admin/communication/website/blocks/_list.html.erb
```

### Show
Le show du bloc utilise le partial de son template
```
views/admin/communication/website/blocks/templates/partners/_show.html.erb
```

### Edit
L'edit du bloc utilise le partial de son template
```
views/admin/communication/website/blocks/templates/partners/_edit.html.erb
```

### Concern
Tous les objets ayant des blocs utilisent le concern `WithBlocks`, qui ajoute la méthode suivante `blocks` (la liste des blocs, dans l'ordre).

### Export statique
Les blocs sont exportés dans le frontmatter grâce au partial
```
views/admin/communication/website/blocks/_static.html.erb
```
qui donne ce type de résultat
```
blocks:
  - kind: partners
    data:
      - name: Partner 1
        url: https://partner1.com
        logo: "e09f3794-44e5-4b51-be02-0e384616e791"
```
Les générateurs de chaque type suivent l'organisation :
```
views/admin/communication/website/blocks/templates/partners/_static.html.erb
```
