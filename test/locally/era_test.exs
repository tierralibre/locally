defmodule Locally.EraTest do
  use Locally.DataCase

  import Locally.AccountsFixtures

  alias Locally.Era

  describe "entities" do
    alias Locally.Era.Entity

    h3index_create = :h3.from_geo({28.626972, -17.811667}, 15) |> :h3.to_string()
    h3index_update = :h3.from_geo({28.626972, -17.811667}, 13) |> :h3.to_string()

    @valid_attrs %{content: %{}, h3index: h3index_create, name: "some name", status: "some status", topics: [], type: "some type"}
    @update_attrs %{content: %{}, h3index: h3index_update, name: "some updated name", status: "some updated status", topics: [], type: "some updated type"}
    @invalid_attrs %{content: nil, h3index: nil, name: nil, status: nil, topics: nil, type: nil}

    def entity_fixture(attrs \\ %{}) do
      user = user_fixture()
      attrs = attrs |> Enum.into(@valid_attrs)
      {:ok, entity} =
        Era.create_entity(user, attrs)
      entity
    end

    test "list_entities/0 returns all entities" do
      entity = entity_fixture()
      assert Era.list_entities() == [entity]
    end

    test "get_entity!/1 returns the entity with given id" do
      entity = entity_fixture()
      assert Era.get_entity!(entity.id) == entity
    end

    test "create_entity/1 with valid data creates a entity" do
      user = user_fixture()
      assert {:ok, %Entity{} = entity} = Era.create_entity(user, @valid_attrs)
      assert entity.content == %{}
      assert entity.h3index == "8f34414a64ce2c9"
      assert entity.name == "some name"
      assert entity.status == "some status"
      assert entity.topics == []
      assert entity.type == "some type"
    end

    test "create_entity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Era.create_entity(user_fixture(), @invalid_attrs)
    end

    test "update_entity/2 with valid data updates the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{} = entity} = Era.update_entity(entity, @update_attrs)
      assert entity.content == %{}
      assert entity.h3index == "8d34414a64c85bf"
      assert entity.name == "some updated name"
      assert entity.status == "some updated status"
      assert entity.topics == []
      assert entity.type == "some updated type"
    end

    test "update_entity/2 with invalid data returns error changeset" do
      entity = entity_fixture()
      assert {:error, %Ecto.Changeset{}} = Era.update_entity(entity, @invalid_attrs)
      assert entity == Era.get_entity!(entity.id)
    end

    test "delete_entity/1 deletes the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{}} = Era.delete_entity(entity)
      assert_raise Ecto.NoResultsError, fn -> Era.get_entity!(entity.id) end
    end

    test "change_entity/1 returns a entity changeset" do
      entity = entity_fixture()
      assert %Ecto.Changeset{} = Era.change_entity(entity)
    end
  end

  describe "transactions" do
    alias Locally.Era.Transaction

    @valid_attrs %{content: %{}, h3index: "some h3index", name: "some name", status: "some status", type: "some type"}
    @update_attrs %{content: %{}, h3index: "some updated h3index", name: "some updated name", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{content: nil, h3index: nil, name: nil, status: nil, type: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Era.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Era.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Era.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Era.create_transaction(@valid_attrs)
      assert transaction.content == %{}
      assert transaction.h3index == "some h3index"
      assert transaction.name == "some name"
      assert transaction.status == "some status"
      assert transaction.type == "some type"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Era.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Era.update_transaction(transaction, @update_attrs)
      assert transaction.content == %{}
      assert transaction.h3index == "some updated h3index"
      assert transaction.name == "some updated name"
      assert transaction.status == "some updated status"
      assert transaction.type == "some updated type"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Era.update_transaction(transaction, @invalid_attrs)
      assert transaction == Era.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Era.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Era.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Era.change_transaction(transaction)
    end
  end
end
