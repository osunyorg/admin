# Export Hugo

## Contexte

Chaque website peut avoir un repository git.
Tous les objets de ce website doivent être synchronisés sur le repository.
Les publications doivent se font en asynchrone parce qu'elles peuvent être longues.


Certains objets peuvent appartenir à plusieurs websites, donc plusieurs repositories, comme par exemple les programs.
Certains objets ont des dépendances, par exemple les pages enfants, les auteurs, les catégories ou les médias.


Les fichiers renommés doivent être déplacés sur git.
Les fichiers supprimés ou dépubliés doivent être supprimés sur git.
Il faut veiller à limiter le nombre de commits et à éviter les commits vides.

## Setup

### GitHub

- Créer un repository à partir du template suivant : https://github.com/noesya/osuny-hugo-template
- Une fois le repository créé, générer un personal access token ici : https://github.com/settings/tokens
  - Permission à accorder : `repo`
  - Durée : pour une bonne sécurité, il n'est pas recommandé de créer un token permanent, notez simplement qu'il faut le régénérer régulièrement.
- Copier le personnal access token
- Dans le back-office d'Osuny, créer ou modifier un website et renseignez les 2 champs relatifs à Git :
  - Repository : `username/repo`
  - Access token : `ghp_xxxxxxxxxxxxxxxxxxxx`

### Déploiement (Netlify)

- Créer un site sur Netlify lié au repository du site
- Dans "Site settings", "Build & deploy", "Environment", "Environment variables", ajouter :
  - `HUGO_VERSION` avec pour valeur la dernière version (ex: `0.92.1`)

La récupération du thème se fait via SSH par défaut. Pour que le déploiement fonctionne correctement, vous pouvez :
- Changer le remote du submodule pour qu'il utilise HTTPS.
- Garder le SSH, cependant il faut :
  - Générer et copier la deploy key du site sur Netlify (dans "Site settings", "Build & deploy" puis "Deploy key").
  - L'ajouter dans la section "Deploy keys" du repository contenant le thème (ici : https://github.com/noesya/osuny-hugo-theme/settings/keys).

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

Ce flux cause un problème majeur : tout ce qui est analysé disparaît en asynchrone.

### Version 2

Après l'enregistrement d'un objet, il faut lancer une tâche asynchrone de synchronisation.
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
  @page.destroy_and_sync
end
```


Pour les reorder, chaque objet doit avoir ses siblings en dépendance, donc il suffit de synchroniser un objet déplacé pour qu'il gère l'ensemble :
```
def reorder
  ...
  pages.first.sync_with_git
end
```

## Code

### Website::WithRepository

Le website a un trait WithRepository qui gère son rapport avec le repository Git, quel que soit le provider (Github, Gitlab...).

### Objets exportables vers Git

Tous les objets qui doivent être exportés vers Git :
- doivent utiliser le concern `WithGit`, qui gère l'export vers les repositories des objets et de leurs dépendances
- peuvent intégrer le concern `WithMedia` s'il utilise des médias (`featured_image` et/ou images dans des rich texts)
- peuvent présenter une méthode `identifiers` qui liste les identifiants des git_files à générer, pour les objets qui créent plusieurs fichiers (le fichier par défaut s'appelle `static`)
- peuvent présenter une méthode `git_dependencies_static` qui liste les dépendances de l'identifiant par défaut `static`
- peuvent présenter une méthode `git_destroy_dependencies_static` qui liste les dépendances à supprimer en cascade de l'identifiant par défaut `static`
- peuvent présenter des méthodes `git_dependencies_author` et/ou `git_destroy_dependencies_author` qui liste les dépendances de l'identifiant `author`

### Modèle Communication::Website::GitFile

La responsabilité de la synchronisation repose sur Communication::Website::GitFile, notamment :
- l'information est-elle intègre, synchronisée avec le repo ? (previous_sha et previous_path cohérents avec le repo git)
- le fichier doit-il être créé ? (pas à supprimer et (non intègre, ou pas de previous_sha/previous_path))
- le fichier doit-il être mis à jour ? (pas à supprimer et (non intègre, ou previous_sha/previous_path différent du sha/path))
- le fichier doit-il être supprimé ? (path nil ou marquage à détruire)


Pour cela, le git_file dispose des propriétés suivantes :
- previous_path (le chemin à la dernière sauvegarde, nil si pas encore créé, ou détruit)
- previous_sha (le hash de la précédente version, utile pour savoir si le fichier a changé)
- identifier (l'identifiant du fichier à créer, `static` par défaut, pour les objets créant plusieurs fichiers)


Pour informer sur les actions à mener, il dispose des méthodes interrogatives suivantes :
- synchronized_with_git? (pour évaluer l'intégrité vs le repository)
- should_create? (pour savoir s'il faut créer ou pas)
- should_update? (pour savoir s'il faut régénérer ou pas)
- should_destroy? (pour savoir s'il faut supprimer)


Pour générer les fichiers, il dispose des méthodes :
- to_s (pour générer le fichier statique à jour)
- sha (pour calculer le hash du fichier à jour)
- path (pour générer le chemin à jour)
