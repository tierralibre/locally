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
Locally.H3Index.h3_geo_to_h3(48.8566, 2.3522, 9) 

"891fb466257ffff"

h3.from_geo({48.8566, 2.3522}, 9) |> :h3.to_string()
'891fb466257ffff'


1> Paris = h3:from_geo({48.8566, 2.3522}, 9).
617550903642685439
2> h3:to_string(Paris).
"891fb466257ffff"
3> h3:to_geo(Paris).
{48.857078058197295,2.3529900909549206}

<<0, 0, 0, 15, 56, 55, 101, 51, 53, 101, 55, 48, 51, 102, 102, 102, 102, 102,
          102, 67, 0, 0, 0, 13, 83, 69, 76, 69, 67, 84, 32, 49, 0, 51, 0, 0, 0, 4, 90,
          0, 0, 0, 5, 73>>

resolution 0

<<0, 0, 0, 15, 56, 48, 101, 51, 102, 102, 102, 102, 102, 102, 102, 102, 102,
          102, 102, 67, 0, 0, 0, 13, 83, 69, 76, 69, 67, 84, 32, 49, 0, 51, 0, 0, 0, 4,
          90, 0, 0, 0, 5, 73>>

resolution 1

<<0, 0, 0, 15, 56, 49, 101, 51, 55, 102, 102, 102, 102, 102, 102, 102, 102, 102,
          102, 67, 0, 0, 0, 13, 83, 69, 76, 69, 67, 84, 32, 49, 0, 51, 0, 0, 0, 4, 90,
          0, 0, 0, 5, 73>>

resolution 2

        <<0, 0, 0, 15, 56, 50, 101, 51, 53, 102, 102, 102, 102, 102, 102, 102, 102, 102,
          102, 67, 0, 0, 0, 13, 83, 69, 76, 69, 67, 84, 32, 49, 0, 51, 0, 0, 0, 4, 90,
          0, 0, 0, 5, 73>>

resolution 15

# 1
        <<0, 0, 0, 15, 56, 102, 55, 97, 97, 53, 49, 52, 53, 99, 101, 101, 53, 50, 49,
          
          67, 0, 0, 0, 13, 83, 69, 76, 69, 67, 84, 32, 49, 0, 51, 0, 0, 0, 4, 90, 0, 0,
          0, 5, 73>>

resolution 14

<<0, 0, 0, 15, 56, 101, 55, 97, 97, 53, 49, 52, 53, 99, 101, 101, 53, 50, 55,
          
          67, 0, 0, 0, 13, 83, 69, 76, 69, 67, 84, 32, 49, 0, 51, 0, 0, 0, 4, 90, 0, 0,
          0, 5, 73>>

# 13
        <<0, 0, 0, 15, 56, 100, 55, 97, 97, 53, 49, 52, 53, 99, 101, 101, 53, 51, 102,
          
          67, 0, 0, 0, 13, 83, 69, 76, 69, 67, 84, 32, 49, 0, 51, 0, 0, 0, 4, 90, 0, 0,
          0, 5, 73>>
Locally.H3Index.h3_geo_to_h3(28.626972, -17.811667, 15) 

:h3.from_geo({28.626972, -17.811667}, 15)

:h3.from_geo({28.626972, -17.811667}, 15) |> :h3.to_string()
'8f34414a64ce2c9'


```
mix phx.gen.live Era Entity entities h3index:string name:string type:string status:string creator_id:references:users  topics:array:string content:map

```