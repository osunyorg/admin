# Osuny

## Domaines

- https://bordeauxmontaigne.osuny.org/admin -> admin
- https://bordeauxmontaigne.osuny.org/alumni -> webservice des alumni, accessible en iframe
- https://bordeauxmontaigne.osuny.org/journal -> workflow publication et review revue scientifique
- https://bordeauxmontaigne.osuny.org/profile -> gestion de son propre profil


Attention, il ne faut pas coder de couplage fort avec osuny.org (utiliser des variables d'env dans models/university/with_idenfier.rb).

On a des objets attachés à l'université "bordeauxmontaigne" :
- ecoles
- campus
- formations
- enseignants
- revues scientifiques
- blogs
- ...

## Sites

1. Choix du about
Au moment de la création on choisit un "about".
Cet "about" peut concerner une université, une école, une revue, ou rien du tout (ex: site de projet étudiant)...

2. Définition du repository
Sélection du repository git avec le site Hugo.
Ex: https://github.com/noesya/bordeauxmontaigne-iut

3. Edition du site
Gestion des objets côté Rails, export statique à l'enregistrement.

4. Paramétrage
Définition des langues, adaptation des chemins et des textes pour chaque langue.
