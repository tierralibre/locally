defmodule Locally.MarketTest do
  use Locally.DataCase

  alias Locally.Market

  describe "stores" do
    alias Locally.Market.Store
    alias Erm.Boundary.ApplicationManager

    @valid_attrs %{
      name: "some name",
      postal_code: "some postal_code",
      postal_direction: "some postal_direction"
    }
    @update_attrs %{
      name: "some updated name",
      postal_code: "some updated postal_code",
      postal_direction: "some updated postal_direction"
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
end
