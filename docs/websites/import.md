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
