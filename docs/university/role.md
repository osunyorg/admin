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

### Exemples

Soient :
- `mmi_program` : l'objet `Education::Program` représentant le BUT MMI
- `teacher` : l'objet `University::Person` représentant un enseignant
- `director` : l'objet `University::Person` représentant la cheffe de département
- `program_manager` : l'objet `University::Person` représentant le directeur des études
- `secretary` : l'objet `University::Person` représentant le secrétaire

Pour l'enseignant on crée un objet `University::Person::Involvement`:
- target: `mmi_program`
- person: `teacher`
- kind: teacher

Pour la cheffe de département on crée :
- Un objet `University::Role`, qu'on nomme `director_role`
  - target: `mmi_program`
  - description: "Cheffe de département"
- Un objet `University::Person::Involvement`
  - target: `director_role`
  - person: `director`
  - kind: administrator

Pour le directeur des études on crée :
- Un objet `University::Role`, qu'on nomme `program_manager_role`
  - target: `mmi_program`
  - description: "Directeur des études"
- Un objet `University::Person::Involvement`
  - target: `program_manager_role`
  - person: `program_manager`
  - kind: administrator

Pour le secrétaire on crée :
- Un objet `University::Role`, qu'on nomme `secretary_role`
  - target: `mmi_program`
  - description: "Secrétaire"
- Un objet `University::Person::Involvement`
  - target: `secretary_role`
  - person: `secretary`
  - kind: administrator
