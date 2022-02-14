# WYSIWYG

## Quels enjeux ?

Permettre l'édition, mais limiter les options graphiques (ni couleurs, ni tailles, ni typos).

Fonctionnalités :
- intégration d'images dans le corps du texte, en gardant la trace du blob active storage, et en les intégrant dans la liste des dépendances.
- intégration de vidéos.
- intégration d'autres formats (Tweets...).

## Solutions techniques

### ActionText

Avantages :
- active storage intégré
- Trix intégré

Inconvénients :
- Pas de modèle (polymorphic)

### Trix

Avantages :
- intégré à ActionText
- très limité

Inconvénients :
- très limité (target blank, 1 seul niveau de titre, pas d'embed, pas de code source)
- pas extensible

### Summernote

Avantages :
- vaste
- extensible

Inconvénients :
- dépendance jQuery
- pas intégré à ActionText
- moyennement robuste quand on le torture

### Page builder custom

Avantages :
- puissant
- souple

Inconvénients :
- compliqué à construire et maintenir
- compliqué à utiliser


## Benchmark

[Refinery](https://www.refinerycms.com/)


[Spina](https://spinacms.com/)


[Alchemy CMS](https://alchemy-cms.com/)


[Locomotive CMS](https://www.locomotivecms.com/)


## Méthode

### action-text-attachment

Dans la BDD, on stocke cette balise :
```
<action-text-attachment sgid="BAh[...]1df3"
                        content-type="image/jpeg"
                        url="http://demo.osuny:3000/rails/active_storage/blobs/redirect/eyJf[...]0f4a1/domenico_bruno_de_lobkowitz_watchingwindows_com_08.jpg" filename="domenico_bruno_de_lobkowitz_watchingwindows_com_08.jpg"
                        filesize="352931"
                        width="588"
                        height="746"
                        previewable="true"
                        presentation="gallery">
</action-text-attachment>
```

A l'édition, la balise est "remplie" avant affichage, pour avoir une preview.
A l'enregistrement, la balise est vidée.

Etapes normales :
-[x] A l'import d'une image, ajouter l'action-text-attachement autour de l'img
-[ ] A la suppression d'une image dans l'éditeur, supprimer l'action-text-attachement autour de l'img
-[x] A l'enregistrement, déshydrater les action-text-attachements
-[x] A l'édition, réhydrater les action-text-attachements
-[ ] Après l'enregistrement mettre à jour les blobs attachés à l'objet parent (le post, par exemple)

Si un programme a 5 champs Summernote avec 3 images dans chaque champ, cela fait 15 attachments à lier au programme.
Si on enlève une image d'un champ, il faut mettre à jour la liste pour avoir les 14 bons attachments.

Etapes de migration :
-[x] Au rails app:fix, transformer le markup Trix en markup Summernote (application_record) dans les propriétés _new
-[ ] Enlever les scripts de l'application_record
-[ ] Supprimer les champs ActionText dans les modèles
-[ ] Supprimer la table d'ActionText
-[ ] Renommer les champs en enlevant _new

Actions de dev :
-[ ] Coder les ajouts aux modèles dans Osuny
-[ ] Coder le JS dans Osuny
-[ ] Une fois que c'est fait, déplacer le Ruby et le JS dans summernote-rails

### Le pdf

Autoriser dans summernote

### Code HTML cible

```
<h2>Titre</h2>
<p>
  Texte normal<br>
  <b>Texte en gras</b><br>
  <i>Texte en italique</i>
  <action-text-attachment sgid="BAh7CEkiCGdpZAY6BkVUSSJUZ2lkOi8vb3N1bnkvQWN0aXZlU3RvcmFnZTo6QmxvYi9hYWUyNDI5OC1kNDE2LTQ2YWMtYTRlNS02ZjY4ZGU2MjFiZDE_ZXhwaXJlc19pbgY7AFRJIgxwdXJwb3NlBjsAVEkiD2F0dGFjaGFibGUGOwBUSSIPZXhwaXJlc19hdAY7AFQw--7e8ead4d79f455499f1d73e8d53a4b8e81a21df3" content-type="image/jpeg" url="http://demo.osuny:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibW...df8140070f4a1/domenico_bruno_de_lobkowitz_watchingwindows_com_08.jpg?website_id=6d8fb0bb-0445-46f0-8954-0e25143e7a58" filename="domenico_bruno_de_lobkowitz_watchingwindows_com_08.jpg" filesize="352931" width="588" height="746" previewable="true" presentation="gallery">
    <figure class="attachment attachment--preview attachment--jpg">
      <picture>
        <source srcset="/rails/active_storage/representations/redirect/eyJfcmFpbHMiOns...XJpYXRpb24ifX0=--7d11fdd26322fef8959415f46d5e2c6d6763b4c0/domenico_bruno_de_lobkowitz_watchingwindows_com_08.jpg 100w, /rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaE...527eb11f95949a389acb1c/domenico_bruno_de_lobkowitz_watchingwindows_com_08.jpg 200w" type="image/webp">
        <source srcset="/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsibW...9fd77765da7c4f647d453b2/domenico_bruno_de_lobkowitz_watchingwindows_com_08.jpg?website_id=6d8fb0bb-0445-46f0-8954-0e25143e7a58 100w, /rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsibW...bb3bc14127bc06ce0d1e32/domenico_bruno_de_lobkowitz_watchingwindows_com_08.jpg?website_id=6d8fb0bb-0445-46f0-8954-0e25143e7a58 200w" type="image/jpeg">
        <img src="/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsi...190ffccd8/domenico_bruno_de_lobkowitz_watchingwindows_com_08.jpg?website_id=6d8fb0bb-0445-46f0-8954-0e25143e7a58" loading="lazy" decoding="async" width="800">
      </picture>
    </figure>
  </action-text-attachment>
  <a href="https://www.u-bordeaux-montaigne.fr/fr/actualites/vie-etudiante/soutenir-les-etudiant-e-s-les-aides-de-l-universite.html">Lien</a>
</p>
```
