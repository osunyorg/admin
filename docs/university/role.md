# University

## Roles

Les personnes d'une université peuvent avoir plusieurs rôles, que ce soit au niveau de l'université ou d'un objet spécifique telle qu'une formation ou un laboratoire.

Ces rôles peuvent être intrinsèques ou non. Par exemple, être enseignant dans une formation est un lien intrinsèque, alors qu'un rôle « directeur des études » dans une formation peut ne pas exister.

Pour cela, on a 2 façons de créer ces liens, à partir d'un modèle commun

### University::Person::Involvement

Ce modèle permet de lier une personne à une cible polymorphique. On définit au niveau de l'objet si l'involvement est de type administratif, enseignant ou chercheur. On renseigne également une description et une position.

### University::Role

Ce modèle sert pour les liens non intrinsèques. On crée un rôle au niveau d'une cible polymorphique, description et position, et possiblement un rôle parent pour définir la hiérarchie au sein d'un organigramme.

Ensuite, on connecte une personne à ce rôle en utilisant le modèle Involvement avec pour target, le rôle en question.
