# Lagoon server

The `lagoon-server` is a
[`servant`](http://hackage.haskell.org/package/servant)-based web server that is
provides REST endpoints that expose the `lagoon-backend` functionality. It is
primarily intended to serve the needs of the `lagoon-webapp` web frontend.

Since this is a `servant`-based server, the web API is defined at the
type-level; the main definition is the `API` type in [`Lagoon.Server.API`](src/Lagoon/Server/API.hs), with
corresponding server

``` haskell
server :: STrans API
```

Both the type-level `API` definition as well as the server itself are split
across multiple modules `Lagoon.Server.API.*`.

## Server monad

The `STrans` type that appears in the signature of `server` is a replacement
of `servant`'s `Server` type; it is defined in [`Lagoon.Server.HandlerM`](src/Lagoon/Server/HandlerM.hs). It replaces `servant`'s `ExceptT`-based monad
stack with an `IO` one, throwing `ServantErr` errors as exceptions instead;
this makes it much easier to make sure code is exception safe.

In addition
our monad stack includes a `Reader` component that records the server environment, which includes both a database connection pool as well as the top-level DB schema we use for the Lagoon metadata tables. This means we can easily execute DB transactions inside our handlers (`execTransaction` and `withConnection`), as well as provide support for defining streaming response bodies that interact with the database (`withConnectionC`). The latter uses some `servant`/`conduit` wrappers that are implemented in [`Lagoon.Server.Servant.Conduit`](src/Lagoon/Server/Servant/Conduit.hs).

## Downloading files

The only functionality (currently) implemented directly in the server code base,
and not available through the command line tool, is downloading files
(`streamCopyData` in [`Lagoon.Server.API.Source`](src/Lagoon/Server/API/Source.hs)). This uses PostgreSQL's COPY OUT protocol to make sure we can stream files in constant space, converting either to CSV or to a JSON file as we go. In the case of JSON files the result might contain multiple top-level JSON values if the underlying table contains multiple rows.
