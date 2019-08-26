_Prendre connaissance de https://hexdocs.pm/phoenix/contexts.html avant de lire ce document. ;)_

**Grouping:**

- `MyAppWeb` - Regroupe ce qui touche au "web"
- `MyAppGraphQL` - Regroupe ce qui touche à GraphQL

**Contextes:**

- `MyApp.Accounts` - Contexte exposant ce qui est lié aux comptes de l’app.
- `MyApp.LinkSharing` - Context exposant la fonctionnalité de share de link utilisé dans 3 autres contextes.

**Modules partagées:**

- `MyApp.Repo` - Module partagé exposant les fonctionnalités pour parler à la DB
- `MyApp.Audits` - Module partagé exposant la fonctionnalité d’audit d’entité
- `MyApp.Permissions` - Module partagé exposant la fonctionnalité de permissions entre resources

## Regroupements versus Contextes

Les regroupements utilises les APIs des contextes dans leurs "leafs" (controllers et resolvers).

## Les grandes lignes des contextes

### Les contextes ne se connaissent pas

`Accounts` n’appelle pas `LinkSharing` après la création d’un user. C’est le controller qui s’occupe des side-effects d’un context.

Comme la façon que `Accounts` utilise `Repo`, un context peut utilisé un autre context partagé pour avoir accès à une fonctionnalité "global" et "abstraite" du système.
"Global" et "abstraite" veut dire que ce n’est pas une fonctionnalité de l’app. `LinkSharing` est une fonctionnalité, `Permissions` non.

> Mais `Audits` devient une fonctionnalité si on a un listing d’historiques dans l’app.

Dans ce cas, un context d’historique pourrait être rendu disponible (qui utiliserait le module partagé `Audits`). Ce context `History` expose un API qui reflèterait la fonctionnalité et qui ne serait pas mêlé au module `Audits` pour qui le role de "prendre n’importe quel action et en garder une trace" ne serait pas touché.

> If you find yourself in similar situations where you feel your use case is requiring you to create circular dependencies across contexts, it’s a sign you need a new context in the system to handle these application requirements. In our case, what we really want is an interface that handles all requirements when a user is created or registers in our application. To handle this, we could create a UserRegistration context, which calls into both the Accounts and CMS APIs to create a user, then associate a CMS author. Not only would this allow our Accounts to remain as isolated as possible, it gives us a clear, obvious API to handle UserRegistration needs in the system.

### Un module de 1000 lignes, c’est oui!

Un context est l’API public d’une des core business de l’app. Le module pour gérer les Enumerable dans Elixir: https://imgur.com/a/IUAyOZM

L’important est de ne pas éparpiller les fonctionnalités. Imaginez le language avec un module `ListSorter`, `ListTaker`, `ArraySlicer`, etc.
C’est pareille pour une application. Le context `Accounts` englobe ce qui est possible de faire `create_user`, `update_user`, `block_user`.

_Un module de 1000 lignes, avec @moduledoc, @doc, @spec, c’est oui!_

### Modules privés dans les contextes

Pour ne pas arriver à un module avec trop de dépendances "direct" (mettont 6 alias, 4 import, 3 use), on sépare les fonctionnalités en groupes:

- **MyApp.Accounts.UserPersistence** Va gérer les intéractions avec le `Repo` et importer `Ecto.Query`
- **MyApp.Accounts.UserSearch** Va gérer l’indexation et la query à Elasticsearch en important le module `Elasticsearch.Query`

Ces modules sont utilisés pour alléger `MyApp.Accounts` et ne devrait en aucun cas _leaker_ dans un controller ou pire, un autre context.
