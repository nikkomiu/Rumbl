defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  alias Rumbl.User

  # Required for scrubbing empty strings into nil
  plug :scrub_params, "user" when action in [:create, :update]
  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, :index, users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, :show, user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, :new, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Rumbl.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
