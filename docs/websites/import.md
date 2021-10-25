# Import

## Contexte

L'objectif est de fluidifier la transition depuis un site déjà en place, notamment WordPress. Deux approches sont possibles : interne, avec un accès BDD, et externe, en passant par le site lui-même. Nous privilégierons l'approche externe dans un premier temps, pour permettre l'approche avant-vente (présenter un site pré-migré).

## Problématiques

1. Détection des pages
2. Extraction des contenus bruts
3. Distingo entre pages et posts, et autres types d'objets
4. Identification des menus

## Approche externe

Plusieurs possibilités :
- le crawling
- le sitemap
- le flux RSS
- l'api

## Approche interne

Plugin, connexion à la BDD, export JSON ou connexion API.

## Développement

Communication::Website::Imported::Website
- university:references
- website:references (has_one Communication::Website)
- status:integer (enum)

Communication::Website::Imported::Page
- university:references
- website:references (has_one Communication::Website::Imported::Website)
- page:references (has_one Communication::Website::Page)
- status:integer (enum)

Etapes :
1. Création du site, avec son URL
2. Lancement de l'import (création de Communication::Website::Imported::Website)
3. Import des sitemaps (création de Communication::Website::Imported::Page)
4. Import du contenu brut des pages importées
5. Analyse du contenu des pages importées et création / mise à jour des pages

## Import depuis WordPress

### Media
1. On importe les media depuis l'API
2. On crée des objets en DB (Communication::Website::Imported::Medium)

### Pages
1. On importe les pages depuis l'API
2. On crée des objets en DB (Communication::Website::Imported::Page)
3. Les objets importés créent ou mettent à jour les objets réels (Communication::Website::Page)
    3.1 sans écraser de modifs locales
    3.2 uniquement si l'import a bougé
    3.3 Le contenu de l'html est filtré
        3.3.1 enlever les balises problématiques
        3.3.2 supprimer les classes
        3.3.3 supprimer les ids
        3.3.4 décaler les titres si h1
    3.4 la featured image est transformée en attachment
    3.5 si pas de featured image, la première image est enlevée du texte et devient featured
    3.6 les medias dans le texte html sont transformés en action text attachments
        3.6.1 lister les files dans le domaine
        3.6.2 identifier le media master correspondant (via data:jsonb)
        3.6.3 s'il n'existe pas, le créer (le cas se produit il ?)
        3.6.4 crée l'attachment
        3.6.5 on remplace le code du media par l'action text attachement

### Posts
Idem pages

## Exemples

### Condé

- https://ecoles-conde.com/sitemap_index.xml
- https://ecoles-conde.com/wp-json/wp/v2/posts
- https://ecoles-conde.com/wp-json/wp/v2/pages

### IUT Bordeaux Montaigne

- https://www.iut.u-bordeaux-montaigne.fr/wp-sitemap.xml
- https://www.iut.u-bordeaux-montaigne.fr/wp-sitemap-posts-post-1.xml
- https://www.iut.u-bordeaux-montaigne.fr/wp-sitemap-posts-page-1.xml
- https://www.iut.u-bordeaux-montaigne.fr/wp-json/wp/v2/posts
- https://www.iut.u-bordeaux-montaigne.fr/wp-json/wp/v2/pages

## Recherches

- https://kinsta.com/fr/blog/api-rest-wordpress/
- https://getshifter.io/
