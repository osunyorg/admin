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

## Program

Bachelor Universitaire de Technologie Métiers du Multimédia et de l'Internet

- university:references
- name:string
- level:integer (enum)
- capacity:integer
- ects:integer
- continuing:boolean
- prerequisites:text
- objectives:text
- duration:text
- registration:text
- pedagogy:text
- evaluation:text
- accessibility:text
+ schools:habtm
+ campuses:habtm

## program/Course

30 heures d'histoire de l'art en année 1

- program:references
- year:references
- name:string
- syllabus:text
- hours:integer

## program/Year

- university:references
- program:references
- year:integer

## program/Session

- name:string
- university:references
- program:references
- from:date
- to:date

## qualiopi/Criterion

- number:integer
- name:text
- description:text

## qualiopi/Indicator
- criterion:references
- number:integer
- name:text
- level_expected:text
- proof:text
- requirement:text
- non_conformity:text

## Website

- university:references
- name:string
- domain:string

## website/Article

- university:references
- title:string
- description:text
- data:json
- published_at:datetime

## website/Page

- university:references
- title:string
- description:text
- data:json
- parent:references

## website/Document

1 document peut concerner :
- toute l'université (charte numérique)
- 1 école (règlement intérieur de l'école)
- 1 campus (règlement intérieur du campus)
- 1 formation (contrat d'alternance type)
- 1 session (calendrier pédagogique de l'année en cours)

- university:references
- name:string
- school:references (optional)
- campus:references (optional)
- program:references (optional)
- session:references (optional)
