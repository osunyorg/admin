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

### Version 1

Lors de l'enregistrement d'un objet, il faut, pour chaque website :
- créer éventuellement le git_file (1 pour chaque website)
- envoyer le git_file (add_to_batch)
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

Ce flux cause un problème majeur : tout ce qui est analysé disparaît en asynchrone

### Version 2

Après l'enregistrement d'un objet, il faut, pour chaque website, lancer une tâche asynchrone de synchronisation.
Cette tâche est lancée par les controllers, et intégrée dans le partial `WithGit`.
```
def create
  if @page.save_and_sync
    ...
  end
end

def update
  if @page.update_and_sync(page_params)
    ...
  end
end

def destroy

end
```

TODO gérer la suppression correctement

## Code

### Website::WithRepository

Le website a un trait WithRepository qui gère son rapport avec le repository Git, quel que soit le provider (Github, Gitlab...).

### Objets exportables vers Git

Tous les objets qui doivent être exportés vers Git :
- doivent utiliser le partial `WithGit`, qui gère l'export vers les repositories des objets et de leurs dépendances
- doivent présenter une méthode `websites`, éventuellement avec un seul website dans un tableau
- peuvent intégrer le concern `WithMedia` s'il utilise des médias (`featured_image` et/ou images dans des rich texts)
- peuvent présenter une méthode `static_files` qui liste les identifiants des git_files à générer, pour les objets qui créent plusieurs fichiers

### GitFile
La responsabilité de la synchronisation repose sur Communication::Website::GitFile, notamment :
- le fichier doit-il être synchronisé ?
- le fichier doit-il être créé ?
- le fichier doit-il être déplacé ?
- le fichier doit-il être supprimé ?


Pour cela, le git_file dispose des propriétés suivantes :
- previous_path (le chemin à la dernière sauvegarde, nil si pas encore créé, ou détruit)
- previous_sha (le hash de la précédente version, utile pour savoir si le fichier a changé)
- identifier (l'identifiant du fichier à créer, `static` par défaut, pour les objets créant plusieurs fichiers)


Et pour générer les fichiers, il dispose des méthodes :
- to_s (pour générer le fichier statique à jour)
- sha (pour calculer le hash du fichier à jour)
- path (pour générer le chemin à jour)
- synced? (pour savoir s'il faut regénérer ou pas)
