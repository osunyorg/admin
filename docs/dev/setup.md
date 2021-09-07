# Setup

As Osuny is multi-university, we need ways to:
- deploy university to production (even without website yet)
- deploy university to staging
- work locally on a specific university

And as each university is multi-website, we need ways to:
- deploy website to production
- deploy website to staging
- work locally on a specific website

## Production

- https://demo.osuny.org
- https://bordeauxmontaigne.osuny.org
- https://clermontauvergne.osuny.org

## Staging

- https://demo.osuny.dev
- https://bordeauxmontaigne.osuny.dev
- https://clermontauvergne.osuny.dev

## Dev

The solution is to set up a host.

/etc/hosts
```
127.0.0.1       demo.osuny
127.0.0.1       bordeauxmontaigne.osuny
127.0.0.1       clermontauvergne.osuny
```

Then we have access on:
- http://demo.osuny:3000
- http://bordeauxmontaigne.osuny:3000
- http://clermontauvergne.osuny:3000
