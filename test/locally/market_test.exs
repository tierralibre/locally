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
end
