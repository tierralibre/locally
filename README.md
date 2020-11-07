# Locally

## Installation

1. Set up the project:

    ```sh
    mix setup
    ```

2. Fire up the Phoenix endpoint:

    ```sh
    mix phx.server
    ```

3. Visit [`localhost:4000`](http://localhost:4000) from your browser.

## App Generation

This app was generated using:

```sh
mix phx.new locally --live
```


```
Ecto.Adapters.SQL.query!(
  Locally.Repo, "SELECT h3_geo_to_h3(POINT('37.3615593,-122.0553238'), $1);", [5]
)

Ecto.Adapters.SQL.query!(
  Locally.Repo, "SELECT h3_geo_to_h3(POINT('37.3615593,-122.0553238'), 5);"
)
```
