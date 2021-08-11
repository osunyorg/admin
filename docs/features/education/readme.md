# Education

## education/Program

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

## education/Course

30 heures d'histoire de l'art en année 1

- program:references
- year:references
- name:string
- syllabus:text
- hours:integer

## education/Year

- university:references
- program:references
- year:integer

## education/Session

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
