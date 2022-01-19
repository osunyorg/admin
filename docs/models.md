# Models

## University

- name:string
- address:string
- zipcode:string
- city:string
- country:string
- private:boolean

## university/School

- university:references
- name:string
- address:string
- zipcode:string
- city:string
- country:string
- latitude:float
- longitude:float

## university/Campus

- university:references
- name:string
- address:string
- zipcode:string
- city:string
- country:string

## university/Section
cf https://conseil-national-des-universites.fr/cnu/

- name:string
- number:integer

## User

- university:references
- first_name:string
- last_name:string
- role:integer (enum: superadmin, admin, visitor)

## university/Person

## university/person/Teacher
