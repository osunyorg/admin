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