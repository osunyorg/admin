# Action Text

*PoC : Ajouter d'un `new_text` sur les `Communication::Website::Post`*

## Ajouts des assets

A partir de la commande `rails g action_text:install`, les styles sont importés en SASS.

Pour la partie JS, avant Rails 7, Action Text n'est fourni qu'en module ES6 prêt pour Babel. Ce format est incompatible avec Sprockets. La solution est de récupérer sur la branche `main` de Rails, le fichier `actiontext/app/assets/javascripts/actiontext.js` et de le mettre dans les vendors pour l'importer via Sprockets.

## Base de données

A partir de la commande `rails g action_text:install`, le fichier de migration pour les rich texts est importé.

On modifie bien la relation polymorphique et l'appel de `create_table` pour utiliser le type UUID.

## Modèle

On rajoute un `has_rich_text :new_text` sur `Communication::Website::Post`, ajout dans les permitted_params, ajout dans le formulaire avec `as: :rich_text_area`, et ajout dans le show.

On crée un initializer pour Action Text car les `ActiveStorage::Blob` uploadés sont rattachés à un objet `ActionText::RichText`, lui-même rattaché au `Communication::Website::Post`.

Ainsi dans l'initializer, on fait déléguer l'appel de `university` et `university_id` au `record` attaché au `ActionText::RichText`.

## Sanitizer

Action Text a sa propre configuration des tags et attributs autorisés dans son sanitizer. On a donc dans l'initializer `action_text.rb`, des appels pour modifier cette configuration.

## Affichage des attachments

TODO