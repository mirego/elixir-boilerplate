***

⚠️ Ces instructions concernent le _boilerplate_ seulement et devraient être retirées une fois le nouveau projet démarré.

1. Cloner ce projet
2. Supprimer le repository Git (`rm -rf .git`)
3. Exécuter le script de renommage de projet (`./project-renamer.sh YourProjectName`)
4. Supprimer le script de renommage de projet
5. Créer un nouveau repository Git (`git init`)
6. Supprimer cette section du fichier `README.md`
7. Créer le premier commit du repository (`git commit -a -m "Initial commit"`)

***

# PhoenixBoilerplate

| Section                                                  | Description                                                            |
|----------------------------------------------------------|------------------------------------------------------------------------|
| [🚧 Dépendances](#-dépendances)                          | Les dépendances techniques du projet et comment les installer          |
| [🏎 Démarrage](#-démarrage)                              | Les détails de mise en route le projet                                 |
| [🏗 Code et architecture](#-code-et-architecture)        | Les différents modules et particularités du _codebase_                 |
| [🔭 Améliorations possibles](#-améliorations-possibles)  | Les différents _refactors_ possibles ainsi que les pistes potentielles |
| [🚑 Résolution de problèmes](#-résolution-de-problèmes)  | Les problèmes récurrents et les solutions reliées                      |
| [🚀 Déploiement](#-déploiement)                          | Les détails du setup de déploiement dans les différents environnements |

## 🚧 Dépendances

* Node.js (`^10.4.1`)
* NPM (`^6.1.0`)
* Elixir (`~1.7.0`)
* Erlang (`~20.1.0`)
* PostgreSQL (`~10.3`)

## 🏎 Démarrage

### Variables d’environnement

Toutes les variables d’environnement nécessaires au démarrage de l’application sont documentées dans le fichier [`.env.dev`](./.env.dev).

Lors d’exécutions de commandes `mix`, il est impératif que toutes ces variables soient présentes dans l’environnement. Pour ce faire, on peut utiliser `source`, [`nv`](https://github.com/jcouture/nv) ou un autre script personnalisé.

### Setup initial

1. Créer les fichiers `.env` et `.env.test` à partir du fichier [`.env.dev`](./.env.dev)
2. Installer les dépendances Mix avec `mix deps.get`
3. Installer les dépendances NPM avec `npm install --prefix assets`
4. Créer et migrer la base de données avec `mix ecto.setup`
5. Compiler l’application avec `mix`
6. Démarrer le serveur Phoenix avec `iex -S mix phx.server`

### Commandes `make`

Un fichier `Makefile` est présent à la racine du code et permet d’effectuer plusieurs tâches courantes. La liste des commandes et leur description sont disponibles via `make help`.

### Base de données

Pour éviter d’avoir à rouler PostgreSQL localement sur sa machine, un fichier `docker-compose.yml` permet de lancer une instance de serveur PostgreSQL dans un container Docker avec `make postgres`.

### Tests

Les tests peuvent être exécutés avec `make test`, toujours avec les bonnes variables d’environnement définies (ie. ne pas utiliser la même base de données définie dans `.env`).

Le taux de couverture des tests peut être calculé avec `make coverage`.

### Lint

Plusieurs outils de lint/formattage peuvent être exécutés pour s’assurer de la constance du code :

* `mix format --check-formatted --dry-run` s’assure que le code Elixir est bien formatté
* `mix credo --strict` s’assure que le code respecte nos bonnes pratiques Elixir
* `mix compile --warnings-as-errors --force` s’assure que la compilation du code Elixir ne soulève aucun avertissement
* `npm --prefix assets run lint-scripts` s’assure que le code respecte nos bonnes pratiques JavaScript
* `npm --prefix assets run lint-styles` s’assure que le code respecte nos bonnes pratiques CSS
* `npm --prefix assets run prettier-check` s’assure que le code JavaScript est bien formatté

### Intégration continue

Le script `priv/scripts/ci-check.sh` roule une multitude de commandes (tests, lint, etc.) pour s’assurer que le projet et son code sont dans un bon état.

## 🏗 Code et architecture

…

## 🔭 Améliorations possibles

| Description | Priorité | Complexité | Pistes |
|-------------|----------|------------|--------|
| …           | …        | …          | …      |

## 🚑 Résolution de problèmes

…

## 🚀 Déploiement

### Distribution OTP

Une nouvelle _release OTP_ peut être créée avec `make build` et testée avec `make run_release`.
