# Citations

A la manière du site Cairn.info, on peut citer des publications.

https://www.cairn.info/revue-recma-2019-4-page-133.htm

Ces citations peuvent avoir différents formats (ou styles), qui sont normalisés.

Par exemple, la norme APA (American Psychological Association) :

```
Bancel, J. (2019). Quelles normes comptables pour une société du commun ? Édouard Jourdain, Éd. Charles Leopold Mayer/Institut Veblen, 2019, 220 pages. RECMA, 354, 133-134. https://doi.org/10.3917/recma.354.0133
```

Ou encore la norme ISO 690

```
BANCEL Jean-Louis, « Quelles normes comptables pour une société du commun ? Édouard Jourdain, Éd. Charles Leopold Mayer/Institut Veblen, 2019, 220 pages », RECMA, 2019/4 (N° 354), p. 133-134. DOI : 10.3917/recma.354.0133. URL : https://www.cairn.info/revue-recma-2019-4-page-133.htm
```

## Analyse des champs

Le processeur de citation CiteProc prend en entrée un objet JSON. Pour obtenir un exemple :
- On télécharge un fichier RIS depuis une publication sur le site de Cairn
- On le convertit au format BibTeX grâce à un site externe : https://www.bibtex.com/c/bibtex-to-ris-converter/ (pensez à changer source/cible)
- On l'importe avec la gem `bibtex-ruby` et on le convertit au format JSON pour CiteProc

```
require 'bibtex'
BibTeX.open('./Cairn-RECMA_354_0133-20220919.bib').to_citeproc
```

```json
{
  "author": [
    {
      "family": "Bancel",
      "given": "Jean-Louis"
    }
  ],
  "title": "Quelles normes comptables pour une société du commun ? Édouard Jourdain, Éd. Charles Leopold Mayer/Institut Veblen, 2019, 220 pages",
  "container-title": "RECMA",
  "publisher": "Association RECMA",
  "volume": "354",
  "issue": "4",
  "page": "133-134",
  "DOI": "10.3917/recma.354.0133",
  "URL": "https://www.cairn.info/revue-recma-2019-4-page-133.htm",
  "language": "FR",
  "issued": {
    "date-parts": [
      [
        2019
      ]
    ]
  },
  "type": "article-journal",
  "id": "RECMA_354_0133"
}
```

De cet objet JSON, on peut en déduire les informations nécessaires à la génération de la citation

- ID : `RECMA_354_0133` (Acronyme revue, n° vol, n° page)
- Auteur : `Bancel, Jean-Louis` (séparation entre nom et prénom)
- Titre : `Quelles normes comptables pour une société du commun ? Édouard Jourdain, Éd. Charles Leopold Mayer/Institut Veblen, 2019, 220 pages`
- Journal : `RECMA`
- Année : `2019`
- Editeur : `Association RECMA`
- Volume : `354`
- Numéro : `4`
- Pages : `133-134`
- DOI : `10.3917/recma.354.0133` (Namespace de Cairn / ID Publication)
- URL : ``
- Langue : `FR`

## Génération des citations

Avec cet objet JSON, on peut ensuite générer la citation avec le style de son choix parmi les styles inclus dans la gem [`csl-styles`](https://github.com/inukshuk/csl-styles).

```ruby
require 'citeproc'
require 'csl/styles'

input = [{...}]

cp_apa = CiteProc::Processor.new style: 'apa', format: 'text'
cp_apa.import input

cp_iso = CiteProc::Processor.new style: 'iso690-author-date-fr-no-abstract', format: 'text'
cp_iso.import input

cp_mla = CiteProc::Processor.new style: 'modern-language-association', format: 'text'
cp_mla.import input

puts "=== APA ==="
puts cp_apa.render :bibliography, id: input["id"]
puts "=== ISO ==="
puts cp_iso.render :bibliography, id: input["id"]
puts "=== MLA ==="
puts cp_mla.render :bibliography, id: input["id"]

# === APA ===
# Houssier, F. (2022). L'œil de Cyclope : une métaphore super-héroïque de transfert. Nouvelle Revue De l'Enfance Et De l'Adolescence, 6(1), 95–108. https://doi.org/10.3917/nrea.006.0095
# === ISO ===
# HOUSSIER, Florian, 2022. L'œil de Cyclope : une métaphore super-héroïque de transfert. Nouvelle Revue de l'Enfance et de l'Adolescence [en ligne]. 2022. Vol. 6, n° 1pp. 95–108. DOI 10.3917/nrea.006.0095. Disponible à l'adresse : https://www.cairn.info/revue-nouvelle-revue-de-l-enfance-et-de-l-adolescence-2022-1-page-95.htm
# === MLA ===
# Houssier, Florian. “L'Œil De Cyclope : Une Métaphore Super-Héroïque De Transfert.” Nouvelle Revue De l'Enfance Et De l'Adolescence, vol. 6, no. 1, 2022, pp. 95–108, https://doi.org/10.3917/nrea.006.0095.
```