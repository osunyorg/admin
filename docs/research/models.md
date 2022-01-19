# Models

## university/person/Researcher (extends university/Person)

... ajouté à university/Person
- situation:string
- habilitation:boolean
- axis:references
- status:enum (statutaire, doctorant, associé)
- research_themes:html

## research/Laboratory

- university:references
- name:string
- address:string
- zipcode:string
- city:string
- country:string
- private:boolean

## research/laboratory/Axis

- university:references
- research_laboratory:references
- name:string
- position:integer
- description:text
- text:html

## research/Thesis

- university:references
- research_laboratory:references
- author:references (person)
- director:references (person)
- title:string
- started_at:date
- presented_at:date
- completed_at:date
