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

## User

- university:references
- first_name:string
- last_name:string
- role:integer (enum: superadmin, admin, visitor)

## user/Teacher

- user:references
- program:references
- title:string
- biography:text

## user/Student

- user:references
- program:references
- year:references
- session:references

## user/Alumnus

- user:references
- program:references
- session:references

## user/Application

- user:references
- program:references
