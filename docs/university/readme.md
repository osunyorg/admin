# University

## Models

### University

- name:string
- address:string
- zipcode:string
- city:string
- country:string
- private:boolean

### university/Person

- university:references
- user:references(optional)
- last_name:string
- first_name
- slug:string
- is_researcher:boolean
- is_teacher:boolean
- is_administrator:boolean
- phone:string
- email:string
- description:text
- habilitation:boolean
- tenure:boolean

### university/Role

### university/role/Person

- university:references
- university_person:references
- university_role:references
- position:integer

### university/School

- university:references
- name:string
- address:string
- zipcode:string
- city:string
- country:string
- latitude:float
- longitude:float

### university/Campus

- university:references
- name:string
- address:string
- zipcode:string
- city:string
- country:string

### university/Section
cf https://conseil-national-des-universites.fr/cnu/

- name:string
- number:integer
