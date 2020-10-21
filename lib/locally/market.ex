defmodule Locally.Market do
  @moduledoc """
  The Market context.
  """

  import Ecto.Query, warn: false

  alias Locally.Market.Store
  alias Locally.Market.ProductCategory
  alias Locally.Market.Product
  alias Erm.Boundary.ApplicationManager

  @app_name "Locally"

  @doc """
  Returns the list of stores.

  ## Examples

      iex> list_stores()
      [%Store{}, ...]

  """
  def list_stores(fields \\ []) do
    ApplicationManager.list_entities(@app_name, :store, fields)
    |> Enum.map(&Store.to_schema(&1))
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
      entity -> Store.to_schema(entity)
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
      {:ok, Store.to_schema(entity)}
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

      {:ok, Store.to_schema(entity)}
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

    {:ok, Store.to_schema(entity)}
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

  @doc """
  Returns the list of product_categories.

  ## Examples

      iex> list_product_categories()
      [%ProductCategory{}, ...]

  """
  def list_product_categories(fields \\ []) do
    ApplicationManager.list_entities(@app_name, :product_category, fields)
    |> Enum.map(&ProductCategory.to_schema(&1))
  end

  @doc """
  Gets a single product_category.

  Raises `Ecto.NoResultsError` if the Product category does not exist.

  ## Examples

      iex> get_product_category!(123)
      %ProductCategory{}

      iex> get_product_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_category!(id) do
    case ApplicationManager.get_entity(@app_name, id) do
      nil -> raise("No results")
      entity -> ProductCategory.to_schema(entity)
    end
  end

  @doc """
  Creates a product_category.

  ## Examples

      iex> create_product_category(%{field: value})
      {:ok, %ProductCategory{}}

      iex> create_product_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_category(attrs \\ %{}) do
    cs = %ProductCategory{} |> ProductCategory.changeset(attrs)

    if cs.valid? do
      %{entity: entity} = ApplicationManager.run_action(@app_name, :add_product_category, attrs)
      {:ok, ProductCategory.to_schema(entity)}
    else
      {:error, cs}
    end
  end

  @doc """
  Updates a product_category.

  ## Examples

      iex> update_product_category(product_category, %{field: new_value})
      {:ok, %ProductCategory{}}

      iex> update_product_category(product_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_category(%ProductCategory{} = product_category, attrs) do
    cs =
      product_category
      |> ProductCategory.changeset(attrs)

    if cs.valid? do
      %{entity: entity} =
        ApplicationManager.run_action(@app_name, :update_product_category, %{
          uuid: product_category.id,
          data: attrs
        })

      {:ok, ProductCategory.to_schema(entity)}
    else
      {:error, cs}
    end
  end

  @doc """
  Deletes a product_category.

  ## Examples

      iex> delete_product_category(product_category)
      {:ok, %ProductCategory{}}

      iex> delete_product_category(product_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_category(%ProductCategory{} = product_category) do
    %{entity: entity} =
      ApplicationManager.run_action(@app_name, :remove_product_category, %{
        uuid: product_category.id
      })

    {:ok, ProductCategory.to_schema(entity)}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_category changes.

  ## Examples

      iex> change_product_category(product_category)
      %Ecto.Changeset{data: %ProductCategory{}}

  """
  def change_product_category(%ProductCategory{} = product_category, attrs \\ %{}) do
    ProductCategory.changeset(product_category, attrs)
  end

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products(fields \\ []) do
    ApplicationManager.list_entities(@app_name, :product, fields)
    |> Enum.map(&Product.to_schema(&1))
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id) do
    case ApplicationManager.get_entity(@app_name, id) do
      nil -> raise("No results")
      entity -> Product.to_schema(entity)
    end
  end

  def get_product_with_categories!(id) do
    case ApplicationManager.get_entity(@app_name, id) do
      nil ->
        raise("No results")

      entity ->
        product = Product.to_schema(entity)

        %Product{
          product
          | categories: [%{uuid: "uuid1", name: "Grocery"}, %{uuid: "uuid2", name: "Fish"}]
        }
    end
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    cs = %Product{} |> Product.changeset(attrs)

    if cs.valid? do
      %{entity: entity} = ApplicationManager.run_action(@app_name, :add_product, attrs)
      {:ok, Product.to_schema(entity)}
    else
      {:error, cs}
    end
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    cs =
      product
      |> Product.changeset(attrs)

    if cs.valid? do
      %{entity: entity} =
        ApplicationManager.run_action(@app_name, :update_product, %{
          uuid: product.id,
          data: attrs
        })

      {:ok, Product.to_schema(entity)}
    else
      {:error, cs}
    end
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    %{entity: entity} =
      ApplicationManager.run_action(@app_name, :remove_product, %{
        uuid: product.id
      })

    {:ok, Product.to_schema(entity)}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end
