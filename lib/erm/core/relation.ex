defmodule Erm.Core.Relation do
  alias Erm.Core.Application

  defstruct [:type, :owner, :from, :to, :data, :valid_from, :valid_to]

  def new(%{type: type, from: from, to: to, data: data}) do
    %__MODULE__{
      type: type,
      from: from,
      to: to,
      owner: nil,
      data: data,
      valid_from: :os.system_time(:millisecond),
      valid_to: nil
    }
  end

  def add_relation(%Application{relations: relations} = application, from, to, type, data) do
    new_rel = new(%{type: type, from: from, to: to, data: data})
    application.persistence.save_relation(application.name, new_rel)
    {:ok, %Application{application | relations: relations ++ [new_rel]}, %{relation: new_rel}}
  end

  def remove_relation(%Application{relations: relations} = application, from, to, type) do
    relation = Enum.find(relations, fn rel -> rel.to == to and rel.from == from end)
    application.persistence.remove_relation(application.name, relation.from, relation.to)
    {:ok,
     %Application{
       application
       | relations:
           Enum.filter(relations, fn rel ->
             rel.type != type or rel.from != from or rel.to != to
           end)
     }, %{relation: relation}}
  end

  def update_relation(%Application{relations: relations} = application, from, to, type, data) do
    rel_to_update =
      Enum.find(relations, fn rel -> rel.type == type and rel.from == from and rel.to == to end)

    new_relation = %__MODULE__{rel_to_update | data: data}
    application.persistence.save_relation(application.name, new_relation)

    {:ok,
     %Application{
       application
       | relations: [
           new_relation
           | Enum.filter(relations, fn rel ->
               rel.type != type or rel.from != from or rel.to != to
             end)
         ]
     }, %{relation: new_relation}}
  end

  def list_relations(%Application{relations: relations}, type, %{from: from, to: to}) do
    Enum.filter(relations, fn rel -> rel.type == type and rel.from == from and rel.to == to end)
  end

  def list_relations(%Application{relations: relations}, type, %{from: from}) do
    Enum.filter(relations, fn rel -> rel.type == type and rel.from == from end)
  end

  def list_relations(%Application{relations: relations}, type, %{to: to}) do
    Enum.filter(relations, fn rel -> rel.type == type and rel.to == to end)
  end

  def list_relations(%Application{relations: relations}, type, %{}) do
    Enum.filter(relations, fn rel -> rel.type == type end)
  end

  def get_relation(%Application{relations: relations}, from, to) do
    Enum.find(relations, fn rel -> rel.from == from and rel.to == to end)
  end
end
