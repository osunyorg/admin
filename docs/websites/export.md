# Export

Tout objet qui doit être exporté sur un ou plusieurs websites doit :
  - avoir une méthode `website` ou `websites`
  - inclure le concern `WithGithubFiles`

S'il possède des médias (`featured_image` et/ou images dans des rich texts), il doit inclure le concern `Communication::Website::WithMedia`

Le concern `WithGithubFiles` ajoute un manifest à l'objet qui permet de définir les fichiers exportés côté GitHub pour celui-ci.

Quand l'objet est sauvegardé, on se base sur le(s) websites et ce manifest pour créer et publier des objets `Communication::Website::GithubFile`. Ces derniers permettent de garder la trace du chemin actuel d'un fichier distant dans le cas où celui-ci viendrait à être déplacé (changement de slug, etc.).

Ces fichiers servent également dans le cas où on souhaite republier manuellement une partie d'un site (exemple : tous les posts), la méthode `Communication::Website#publish_posts!` peut tout grouper en un batch.
