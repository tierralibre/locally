defmodule Locally.Market do
  @moduledoc """
  The Market context.
  """

  import Ecto.Query, warn: false

  alias Locally.Market.Store
  alias Erm.Boundary.ApplicationManager

  @app_name "Locally"

  @doc """
  Returns the list of stores.

  ## Examples

      iex> list_stores()
      [%Store{}, ...]

  """
  def list_stores do
    ApplicationManager.list_entities(@app_name, :store)
    |> Enum.map(&Store.to_store(&1))
  end

  @doc """
  Gets a single store.

  Raises `Ecto.NoResultsError` if the Store does not exist.

  ## Examples

      iex> get_store!(123)
      %Store{}

      iex> get_store!(456)
      ** (Ecto.NoResultsError)

  """
  def get_store!(id) do
    case ApplicationManager.get_entity(@app_name, id) do
      nil -> raise("No results")
      entity -> Store.to_store(entity)
    end
  end

  @doc """
  Creates a store.

  ## Examples

      iex> create_store(%{field: value})
      {:ok, %Store{}}

      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_store(attrs \\ %{}) do
    cs = %Store{} |> Store.changeset(attrs)

    if cs.valid? do
      %{entity: entity} = ApplicationManager.run_action(@app_name, :add_store, attrs)
      {:ok, Store.to_store(entity)}
    else
      {:error, cs}
    end
  end

  @doc """
  Updates a store.

  ## Examples

      iex> update_store(store, %{field: new_value})
      {:ok, %Store{}}

      iex> update_store(store, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_store(%Store{} = store, attrs) do
    cs =
      store
      |> Store.changeset(attrs)

    if cs.valid? do
      %{entity: entity} =
        ApplicationManager.run_action(@app_name, :update_store, %{uuid: store.id, data: attrs})

      {:ok, Store.to_store(entity)}
    else
      {:error, cs}
    end
  end

  @doc """
  Deletes a store.

  ## Examples

      iex> delete_store(store)
      {:ok, %Store{}}

      iex> delete_store(store)
      {:error, %Ecto.Changeset{}}

  """
  def delete_store(%Store{} = store) do
    %{entity: entity} = ApplicationManager.run_action(@app_name, :remove_store, %{uuid: store.id})

    {:ok, Store.to_store(entity)}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking store changes.

  ## Examples

      iex> change_store(store)
      %Ecto.Changeset{data: %Store{}}

  """
  def change_store(%Store{} = store, attrs \\ %{}) do
    Store.changeset(store, attrs)
  end
end
