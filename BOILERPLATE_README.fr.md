# ElixirBoilerplate

| Section                                                 | Description                                                        |
| ------------------------------------------------------- | ------------------------------------------------------------------ |
| [🎯 Objectifs et contexte](#-objectifs-et-contexte)     | Introduction et contexte du projet                                 |
| [🚧 Dépendances](#-dépendances)                         | Dépendances techniques et comment les installer                    |
| [🏎 Départ rapide](#-départ-rapide)                      | Détails sur comment démarrer rapidement le développement du projet |
| [🏗 Code et architecture](#-code-et-architecture)        | Détails sur les composantes techniques de l’application            |
| [🔭 Améliorations possibles](#-améliorations-possibles) | Améliorations, idées et _refactors_ potentiels                     |
| [🚑 Problèmes et solutions](#-problèmes-et-solutions)   | Problèmes récurrents et solutions éprouvées                        |
| [🚀 Déploiement](#-deploiement)                         | Détails pour le déploiement dans différents environnements         |

## 🎯 Objectifs et contexte

…

### Support de navigateurs

| Navigateur | OS  | Contrainte |
| ---------- | --- | ---------- |
| …          | …   | …          |

## 🚧 Dépendances

- Node.js (`>= 10.16, < 11.0`)
- NPM (`>= 6.9, < 7.0`)
- Elixir (`~> 1.9`)
- Erlang (`~> 22.0`)
- PostgreSQL (`~> 10.0`)

## 🏎 Départ rapide

### Variables d’environnement

Toutes les variables d’environnement requises sont documentées dans [`.env.dev`](./.env.dev).

Ces variables doivent être présentes dans l’environnement lorsque des commandes `mix` ou `make` sont exécutées. Plusieurs moyens sont à votre disposition pour ça, mais l’utilisation de [`nv`](https://github.com/jcouture/nv) est recommandée puisqu’elle fonctionne _out of the box_ avec les fichiers `.env.*`.

### Mise en place initiale

1. Créer `.env.dev.local` et `.env.test.local` à partir des valeurs vides de [`.env.dev`](./.env.dev) and [`.env.test`](./.env.test)
2. Installer les dépendances Mix et NPM avec `make dependencies`
3. Générer des valeurs pour les _secrets_ dans [`.env.dev`](./.env.dev) avec `mix phx.gen.secret`

Ensuite, avec les variables de `.env.dev` et `.env.dev.local` présentes dans l’environnement :

1. Créer et migrer la base de données avec `mix ecto.setup`
2. Démarrer le serveur Phoenix avec `make run`

### Commandes `make`

Un fichier `Makefile` est présent à la racine et expose des tâches communes. La liste de ces tâches est disponible via `make help`.

### Base de données

Pour éviter de rouler PostgreSQL localement sur votre machine, un fichier `docker-compose.yml` est inclus pour permettre le démarrage d’un serveur PostgreSQL dans un _container_ Docker avec `docker-compose up postgresql`.

### Tests

La suite de tests peut être exécutée avec `make test` et le niveau de couverture de celle-ci peut être calculé et validé avec `make check-code-coverage`.

### _Linting_ et _formatting_

Plusieurs outils de _linting_ et de _formatting_ peuvent être exécutés pour s’assurer du respect des bonnes pratiques de code :

- `make lint-elixir` s’assure que le code Elixir respecte nos bonnes pratiques
- `make lint-scripts` s’assure que le code JavaScript respecte nos bonnes pratiques
- `make lint-styles` s’assure que le code SCSS respecte nos bonnes pratiques
- `make check-format` valide que le code est bien formatté
- `make format` formatte les fichiers en utilisant Prettier et `mix format`

### Intégration continue

Le script `priv/scripts/ci-check.sh` exécute un ensemble de commantes (tests, _linting_, etc.) pour s’assurer que le projet et son code sont en bon état.

## 🏗 Code et architecture

…

## 🔭 Améliorations possibles

| Description | Priorité | Complexité | Idées |
| ----------- | -------- | ---------- | ----- |
| …           | …        | …          | …     |

## 🚑 Problèmes et solutions

…

## 🚀 Deploiement

### Versions et branches

Chaque déploiement est effectué à partir d’un tag Git. La version du _codebase_ est gérée avec [`incr`](https://github.com/jcouture/incr).

### _Container_

Un _container_ Docker exposant une _release OTP_ peut être créé avec `make build`, testé avec `docker-compose up application` et poussé dans un registre avec `make push`.
