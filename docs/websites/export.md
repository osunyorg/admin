# Export

## Contexte

Chaque website peut avoir un repository git.
Tous les objets de ce website doivent être synchronisés sur le repository.
Les publications doivent se font en asynchrone parce qu'elles peuvent être longues.


Certains objets peuvent appartenir à plusieurs websites, donc plusieurs repositories, comme par exemple les programs.
Certains objets ont des dépendances, par exemple les pages enfants, les auteurs ou les catégories.


Les fichiers renommés doivent être déplacés sur git.
Les fichiers supprimés ou dépubliés doivent être supprimés sur git.
Il faut veiller à limiter le nombre de commits, et éviter les commits vides.

## Architecture

Les git::providers permettent de dialoguer avec les services comme Github et Gitlab.
Le git::repository sert de façade et abstrait le provider.


Chaque objet publiable utilise un objet active record Communication::Website::GitFile qui garde la trace du dernier chemin et du SHA.

## Flux

Lors de l'enregistrement d'un objet, il faut :
- créer éventuellement ses git_files (1 pour chaque website)
- envoyer les git_files aux repositories (add_to_batch)
- modifier ses dépendances, qui créent leur git_files pour chaque repository
- envoyer les git_files des dépendances aux repositories respectifs (add_to_batch)
- pour chaque website, si au moins un fichier a été ajouté :
    - déclencher une modification (touch), qui génère une action asynchrone :
        - pour chaque file :
            - générer le fichier statique
            - calculer le SHA
            - comparer au SHA stocké
            - needs_sync si SHA différent ou path différent
        - si au moins un needs_sync :
            - créer un commit pour tout ça
            - push
            - mettre à jour les previous_path et les SHA des git_files

## Code

Tout objet qui doit être exporté sur un ou plusieurs websites doit :
  - avoir une méthode `website` ou `websites`
  - inclure le concern `WithGithubFiles`

S'il possède des médias (`featured_image` et/ou images dans des rich texts), il doit inclure le concern `Communication::Website::WithMedia`

Le concern `WithGithubFiles` ajoute un manifest à l'objet qui permet de définir les fichiers exportés côté GitHub pour celui-ci.

Quand l'objet est sauvegardé, on se base sur le(s) websites et ce manifest pour créer et publier des objets `Communication::Website::GithubFile`. Ces derniers permettent de garder la trace du chemin actuel d'un fichier distant dans le cas où celui-ci viendrait à être déplacé (changement de slug, etc.).

Ces fichiers servent également dans le cas où on souhaite republier manuellement une partie d'un site (exemple : tous les posts), la méthode `Communication::Website#publish_posts!` peut tout grouper en un batch.
