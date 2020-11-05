defmodule LocallyWeb.Router do
  use LocallyWeb, :router

  import LocallyWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LocallyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", LocallyWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LocallyWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", LocallyWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", LocallyWeb do
    pipe_through [:browser, :require_authenticated_user]

    # store
    live "/stores", StoreLive.Index, :index
    live "/stores/new", StoreLive.Index, :new
    live "/stores/:id/edit", StoreLive.Index, :edit

    live "/stores/:id", StoreLive.Show, :show
    live "/stores/:id/show/edit", StoreLive.Show, :edit

    # product category
    live "/product_categories", ProductCategoryLive.Index, :index
    live "/product_categories/new", ProductCategoryLive.Index, :new
    live "/product_categories/:id/edit", ProductCategoryLive.Index, :edit

    live "/product_categories/:id", ProductCategoryLive.Show, :show
    live "/product_categories/:id/show/edit", ProductCategoryLive.Show, :edit

    # products
    live "/products", ProductLive.Index, :index
    live "/products/new", ProductLive.Index, :new
    live "/products/:id/edit", ProductLive.Index, :edit

    live "/products/:id/show/edit", ProductLive.Show, :edit

    # stocks
    live "/stocks", StockLive.Index, :index
    live "/stocks/new", StockLive.Index, :new
    live "/stocks/:id/edit", StockLive.Index, :edit

    live "/stocks/:id", StockLive.Show, :show
    live "/stocks/:id/show/edit", StockLive.Show, :edit

    # users
    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", LocallyWeb do
    pipe_through [:browser]

    live "/", HomeLive
    live "/products/:id", ProductLive.Show, :show
    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
