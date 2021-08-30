# Osuny

## Domaines

https://bordeauxmontaigne.osuny.org/alumni -> webservice des alumni, accessible en iframe
https://bordeauxmontaigne.osuny.org/admin -> admin
https://bordeauxmontaigne.osuny.org/profile -> gestion de son propre profil


Il ne doit pas y avoir de couplage fort avec osuny.org dans le code (variables d'env dans models/university/with_idenfier.rb).

On a des objets attachés à l'université "bordeauxmontaigne" :
- ecoles
- campus
- formations
- enseignants
- revues scientifiques
- blogs
- ...

## Sites

On peut créer des sites autonomes.

1. Choix du about
Au moment de la création on choisit un about (à terme peut-être plusieurs).
Cet "about" peut concerner une université, une école, une revue, ou rien du tout (ex: site de projet étudiant)...

2. Choix des langues
Français par défaut

3. Définition du repository
Sélection du repository git avec le site en Jekyll.
On peut imaginer le schéma par défaut suivant :
https://github.com/osuny-org/bordeauxmontaigne-iut
Ou bien des repositories spécifiques gérés par l'Université.

4.1 Création du repo
Si le repo n'existe pas, création depuis un template, par exemple :
https://github.com/osuny-org/school

4.2 Sélection du repo
Si le repo existe, connexion au repository.

5. Edition du site
Idem Netlify CMS, passerelle git, création des pages en fonction des collections disponibles et publication sur le git. Certains objets (formations) devront exister en BDD et être transformés en markdown ou html.
