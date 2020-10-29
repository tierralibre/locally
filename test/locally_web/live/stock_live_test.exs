defmodule LocallyWeb.StockLiveTest do
  use LocallyWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Locally.Market

  @create_attrs %{existence: true, price: 42, units: 42}
  @update_attrs %{existence: false, price: 43, units: 43}
  @invalid_attrs %{existence: nil, price: nil, units: nil}

  defp fixture(:stock) do
    {:ok, stock} = Market.create_stock(@create_attrs)
    stock
  end

  defp create_stock(_) do
    stock = fixture(:stock)
    %{stock: stock}
  end

  describe "Index" do
    setup [:create_stock]

    test "lists all stocks", %{conn: conn, stock: stock} do
      {:ok, _index_live, html} = live(conn, Routes.stock_index_path(conn, :index))

      assert html =~ "Listing Stocks"
    end

    test "saves new stock", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.stock_index_path(conn, :index))

      assert index_live |> element("a", "New Stock") |> render_click() =~
               "New Stock"

      assert_patch(index_live, Routes.stock_index_path(conn, :new))

      assert index_live
             |> form("#stock-form", stock: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#stock-form", stock: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.stock_index_path(conn, :index))

      assert html =~ "Stock created successfully"
    end

    test "updates stock in listing", %{conn: conn, stock: stock} do
      {:ok, index_live, _html} = live(conn, Routes.stock_index_path(conn, :index))

      assert index_live |> element("#stock-#{stock.id} a", "Edit") |> render_click() =~
               "Edit Stock"

      assert_patch(index_live, Routes.stock_index_path(conn, :edit, stock))

      assert index_live
             |> form("#stock-form", stock: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#stock-form", stock: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.stock_index_path(conn, :index))

      assert html =~ "Stock updated successfully"
    end

    test "deletes stock in listing", %{conn: conn, stock: stock} do
      {:ok, index_live, _html} = live(conn, Routes.stock_index_path(conn, :index))

      assert index_live |> element("#stock-#{stock.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#stock-#{stock.id}")
    end
  end

  describe "Show" do
    setup [:create_stock]

    test "displays stock", %{conn: conn, stock: stock} do
      {:ok, _show_live, html} = live(conn, Routes.stock_show_path(conn, :show, stock))

      assert html =~ "Show Stock"
    end

    test "updates stock within modal", %{conn: conn, stock: stock} do
      {:ok, show_live, _html} = live(conn, Routes.stock_show_path(conn, :show, stock))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Stock"

      assert_patch(show_live, Routes.stock_show_path(conn, :edit, stock))

      assert show_live
             |> form("#stock-form", stock: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#stock-form", stock: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.stock_show_path(conn, :show, stock))

      assert html =~ "Stock updated successfully"
    end
  end
end
