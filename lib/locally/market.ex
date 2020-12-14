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
    ApplicationManager.list_entities(@app_name, "store", fields)
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
    ApplicationManager.list_entities(@app_name, "product_category", fields)
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

  def search_products(search) do
    list_products()
    |> Enum.filter(fn product -> String.downcase(product.name) =~ String.downcase(search) end)
    |> fill_products_with_stock()
  end

  defp fill_products_with_stock(products) do
    Enum.map(products,fn product -> fill_product_with_stock(product) end)
  end

  defp fill_product_with_stock(%Product{} = product) do
    %Product{product | stock: list_stocks_by_product(product.id)}
  end


  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products(fields \\ []) do
    ApplicationManager.list_entities(@app_name, "product", fields)
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
      entity -> Product.to_schema(entity) |> fill_product_with_stock()
    end
  end

  def get_product_with_categories!(id) do
    case ApplicationManager.get_entity(@app_name, id) do
      nil ->
        raise("No results")

      entity ->
        product = Product.to_schema(entity)

        categories =
          ApplicationManager.list_entities_by_relation(
            @app_name,
            "belongs_category",
            :to,
            entity.id
          )
          |> Enum.map(fn entity -> entity |> ProductCategory.to_schema() |> Map.from_struct() end)
          |> Jason.encode!()

        %Product{
          product
          | categories: categories
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
  def create_product(%{"categories" => categories_jason} = attrs \\ %{}) do
    cs = %Product{} |> Product.changeset(attrs)

    if cs.valid? do
      %{entity: entity} = ApplicationManager.run_action(@app_name, :add_product, attrs)

      Jason.decode!(categories_jason)
      |> update_categories(entity)

      {:ok, Product.to_schema(entity)}
    else
      {:error, cs}
    end
  end

  defp update_categories(categories, entity) do
    Enum.filter(categories, fn cat -> cat["deleted"] end)
    |> Enum.each(fn cat ->
      ApplicationManager.run_action(@app_name, :remove_product_from_category, %{
        from: entity.id,
        to: cat["id"]
      })
    end)

    Enum.filter(categories, fn cat -> !cat["deleted"] end)
    |> Enum.each(fn cat ->
      ApplicationManager.run_action(@app_name, :add_product_to_category, %{
        from: entity.id,
        to: cat["id"]
      })
    end)
  end

  @spec update_product(
          Locally.Market.Product.t(),
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: {:error, Ecto.Changeset.t()} | {:ok, map}
  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{categories: categories_jason} = product, attrs) do
    cs =
      product
      |> Product.changeset(attrs)

    if cs.valid? do
      %{entity: entity} =
        ApplicationManager.run_action(@app_name, :update_product, %{
          uuid: product.id,
          data: attrs
        })

      Jason.decode!(categories_jason)
      |> update_categories(entity)

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

  alias Locally.Market.Stock

  @doc """
  Returns the list of stocks.

  ## Examples

      iex> list_stocks()
      [%Stock{}, ...]

  """
  def list_stocks(%{} = properties \\ %{}) do
    ApplicationManager.list_relations(@app_name, "stock", properties)
    |> Enum.map(&Stock.to_schema(&1))
  end

  def list_stocks_by_store(store_id) do
    list_stocks(%{from: store_id})
    |> Enum.map(fn stock -> fill_stock_product_name(stock) end)
  end

  def list_stocks_by_product(product_id) do
    list_stocks(%{to: product_id})
    |> fill_stocks_with_store()
  end

  defp fill_stocks_with_store(stocks) do
    Enum.map(stocks,& fill_stock_with_store(&1) )
  end

  defp fill_stock_with_store(%Stock{} = stock) do
    %Stock{ stock | store_name: get_store!(stock.from).name}
  end

  defp fill_stock_product_name(stock) do
    %Stock{stock | product_name: get_product!(stock.to).name}
  end

  @doc """
  Gets a single stock.

  Raises `Ecto.NoResultsError` if the Stock does not exist.

  ## Examples

      iex> get_stock!(123)
      %Stock{}

      iex> get_stock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stock!([from, to]) do
    case ApplicationManager.get_relation(@app_name, "stock", from, to) do
      nil ->
        raise("No results")

      relation ->
        Stock.to_schema(relation)
        |> fill_stock_product_name()
        |> fill_stock_with_store()
    end
  end

  @doc """
  Creates a stock.

  ## Examples

      iex> create_stock(%{field: value})
      {:ok, %Stock{}}

      iex> create_stock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stock(attrs \\ %{}) do
    cs = %Stock{} |> Stock.changeset(attrs)

    if cs.valid? do
      %{relation: relation} = ApplicationManager.run_action(@app_name, :add_stock, attrs)
      {:ok, Stock.to_schema(relation)}
    else
      {:error, cs}
    end
  end

  @doc """
  Updates a stock.

  ## Examples

      iex> update_stock(stock, %{field: new_value})
      {:ok, %Stock{}}

      iex> update_stock(stock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock(%Stock{} = stock, attrs) do
    cs =
      stock
      |> Stock.changeset(attrs)

    if cs.valid? do
      %{relation: relation} =
        ApplicationManager.run_action(@app_name, :update_stock, %{
          from: stock.from,
          to: stock.to,
          data: attrs
        })

      {:ok, Stock.to_schema(relation)}
    else
      {:error, cs}
    end
  end

  @doc """
  Deletes a stock.

  ## Examples

      iex> delete_stock(stock)
      {:ok, %Stock{}}

      iex> delete_stock(stock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock(%Stock{} = stock) do
    %{relation: relation} =
      ApplicationManager.run_action(@app_name, :remove_stock, %{
        from: stock.from,
        to: stock.to
      })

    {:ok, Stock.to_schema(relation)}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock changes.

  ## Examples

      iex> change_stock(stock)
      %Ecto.Changeset{data: %Stock{}}

  """
  def change_stock(%Stock{} = stock, attrs \\ %{}) do
    Stock.changeset(stock, attrs)
  end
end
