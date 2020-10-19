defmodule Locally.MarketTest do
  use Locally.DataCase

  alias Locally.Market

  describe "stores" do
    alias Locally.Market.Store
    alias Erm.Boundary.ApplicationManager

    @valid_attrs %{
      "name" => "some name",
      "postal_code" => "some postal_code",
      "postal_direction" => "some postal_direction",
      "owner_id" => "2938792-239847923-23984729837"
    }
    @update_attrs %{
      "name" => "some updated name",
      "postal_code" => "some updated postal_code",
      "postal_direction" => "some updated postal_direction",
      "owner_id" => "totally-different-ownid"
    }
    @invalid_attrs %{name: nil, postal_code: nil, postal_direction: nil}
    @app_name "Locally"

    def store_fixture(attrs \\ %{}) do
      ApplicationManager.reset_app(@app_name)

      {:ok, store} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Market.create_store()

      store
    end

    test "list_stores/0 returns all stores" do
      store = store_fixture()
      assert Market.list_stores() == [store]
    end

    test "get_store!/1 returns the store with given id" do
      store = store_fixture()
      assert Market.get_store!(store.id) == store
    end

    test "create_store/1 with valid data creates a store" do
      assert {:ok, %Store{} = store} = Market.create_store(@valid_attrs)
      assert store.name == "some name"
      assert store.postal_code == "some postal_code"
      assert store.postal_direction == "some postal_direction"
    end

    test "create_store/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_store(@invalid_attrs)
    end

    test "update_store/2 with valid data updates the store" do
      store = store_fixture()
      assert {:ok, %Store{} = store} = Market.update_store(store, @update_attrs)
      assert store.name == "some updated name"
      assert store.postal_code == "some updated postal_code"
      assert store.postal_direction == "some updated postal_direction"
    end

    test "update_store/2 with invalid data returns error changeset" do
      store = store_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_store(store, @invalid_attrs)
      assert store == Market.get_store!(store.id)
    end

    test "delete_store/1 deletes the store" do
      store = store_fixture()
      assert {:ok, %Store{}} = Market.delete_store(store)
      assert_raise RuntimeError, fn -> Market.get_store!(store.id) end
    end

    test "change_store/1 returns a store changeset" do
      store = store_fixture()
      assert %Ecto.Changeset{} = Market.change_store(store)
    end
  end

  describe "product_categories" do
    alias Locally.Market.ProductCategory
    alias Erm.Boundary.ApplicationManager

    @valid_attrs %{"name" => "some name"}
    @update_attrs %{"name" => "some updated name"}
    @invalid_attrs %{"name" => nil}

    def product_category_fixture(attrs \\ %{}) do
      ApplicationManager.reset_app(@app_name)

      {:ok, product_category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Market.create_product_category()

      product_category
    end

    test "list_product_categories/0 returns all product_categories" do
      product_category = product_category_fixture()
      assert Market.list_product_categories() == [product_category]
    end

    test "get_product_category!/1 returns the product_category with given id" do
      product_category = product_category_fixture()
      assert Market.get_product_category!(product_category.id) == product_category
    end

    test "create_product_category/1 with valid data creates a product_category" do
      assert {:ok, %ProductCategory{} = product_category} =
               Market.create_product_category(@valid_attrs)

      assert product_category.name == "some name"
    end

    test "create_product_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_product_category(@invalid_attrs)
    end

    test "update_product_category/2 with valid data updates the product_category" do
      product_category = product_category_fixture()

      assert {:ok, %ProductCategory{} = product_category} =
               Market.update_product_category(product_category, @update_attrs)

      assert product_category.name == "some updated name"
    end

    test "update_product_category/2 with invalid data returns error changeset" do
      product_category = product_category_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Market.update_product_category(product_category, @invalid_attrs)

      assert product_category == Market.get_product_category!(product_category.id)
    end

    test "delete_product_category/1 deletes the product_category" do
      product_category = product_category_fixture()
      assert {:ok, %ProductCategory{}} = Market.delete_product_category(product_category)
      assert_raise RuntimeError, fn -> Market.get_product_category!(product_category.id) end
    end

    test "change_product_category/1 returns a product_category changeset" do
      product_category = product_category_fixture()
      assert %Ecto.Changeset{} = Market.change_product_category(product_category)
    end
  end

  describe "products" do
    alias Locally.Market.Product
    alias Erm.Boundary.ApplicationManager

    @valid_attrs %{
      "bar_code" => "some bar_code",
      "brand" => "some brand",
      "depht" => 42,
      "description" => "some description",
      "details" => "some details",
      "discontinued" => true,
      "height" => 42,
      "model" => "some model",
      "name" => "some name",
      "weight" => 42,
      "width" => 42
    }
    @update_attrs %{
      "bar_code" => "some updated bar_code",
      "brand" => "some updated brand",
      "depht" => 43,
      "description" => "some updated description",
      "details" => "some updated details",
      "discontinued" => false,
      "height" => 43,
      "model" => "some updated model",
      "name" => "some updated name",
      "weight" => 43,
      "width" => 43
    }
    @invalid_attrs %{
      "bar_code" => nil,
      "brand" => nil,
      "depht" => nil,
      "description" => nil,
      "details" => nil,
      "discontinued" => nil,
      "height" => nil,
      "model" => nil,
      "name" => nil,
      "weight" => nil,
      "width" => nil
    }

    def product_fixture(attrs \\ %{}) do
      ApplicationManager.reset_app(@app_name)

      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Market.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Market.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Market.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Market.create_product(@valid_attrs)
      assert product.bar_code == "some bar_code"
      assert product.brand == "some brand"
      assert product.depht == 42
      assert product.description == "some description"
      assert product.details == "some details"
      assert product.discontinued == true
      assert product.height == 42
      assert product.model == "some model"
      assert product.name == "some name"
      assert product.weight == 42
      assert product.width == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Market.update_product(product, @update_attrs)
      assert product.bar_code == "some updated bar_code"
      assert product.brand == "some updated brand"
      assert product.depht == 43
      assert product.description == "some updated description"
      assert product.details == "some updated details"
      assert product.discontinued == false
      assert product.height == 43
      assert product.model == "some updated model"
      assert product.name == "some updated name"
      assert product.weight == 43
      assert product.width == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_product(product, @invalid_attrs)
      assert product == Market.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Market.delete_product(product)
      assert_raise RuntimeError, fn -> Market.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Market.change_product(product)
    end
  end
end
