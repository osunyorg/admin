# Customs

## communication/website/custom/Type

- university:references
- website:references
- name:string
- identifier:string
- position:integer
- order:boolean
- tree:boolean
- date:boolean

## communication/website/custom/type/Property

- university:references
- website:references
- type:references
- name:string
- kind:integer (enum)
- position

## communication/website/custom/Element

- university:references
- website:references
- type:references
- name:string
- slug:string
- published:boolean
- published_at:datetime
- parent:references
- position:integer
- data:jsonb
