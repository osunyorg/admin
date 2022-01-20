## Models

### university/person/Researcher (extends university/Person)

... ajouté à university/Person
- habilitation:boolean
- tenure:boolean

### research/Laboratory

- university:references
- name:string
- address:string
- zipcode:string
- city:string
- country:string

### research/laboratory/Axis

- university:references
- research_laboratory:references
- name:string
- position:integer
- description:text
- text:html

### research/Thesis

- university:references
- research_laboratory:references
- author:references (person)
- director:references (person)
- title:string
- abstract:text
- started_at:date
- completed:boolean
- completed_at:date

### research/laboratory/Involvement (tbc)

- university:references
- research_laboratory:references
- university_person:references
- research_axis:references
- status:enum (statutaire, doctorant, associé)
- description:string
- themes:html
