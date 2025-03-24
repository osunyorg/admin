# Github optimization

## v1 Création d'un nouveau site sans fonctionnalités

140 requêtes loggées

107     INFO -- : request: GET
21      INFO -- : request: POST
10      INFO -- : request: PATCH
2       INFO -- : request: PUT

## v2 Activation du cache Faraday

x-ratelimit-used: "1000"
x-ratelimit-used: "1138"

140 requêtes

shared_cache: false et toutes les requêtes sont privées, donc pas de cache

## v3 shared_cache: true

x-ratelimit-used: "1344"
x-ratelimit-used: "1533"

140 requêtes

## v4 set store

x-ratelimit-used: "1681"
x-ratelimit-used: "1843"

140 requêtes


## v5 shared_cache: false

On avait compris à l'envers :)

x-ratelimit-used: "1919"
x-ratelimit-used: "1923"

On a juste récupéré des ressources, pas de gain.

https://evilmartians.com/chronicles/down-the-caching-hole-adventures-in-http-caching-and-faraday-land

-> on supprime le cache


## v12 early returns

On n'interroge plus l'API pour `valid?` ni pour `default_branch`

76 requêtes (gain de 64 !)

x-ratelimit-used: "442"
x-ratelimit-used: "526"


43   GET
21   POST (la génération, les arbres et les commits)
10   PATCH (les mises à jour de main)
2    PUT (les secrets)