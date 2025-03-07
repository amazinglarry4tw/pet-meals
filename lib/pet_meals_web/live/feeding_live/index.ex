defmodule PetMealsWeb.FeedingLive.Index do
  use PetMealsWeb, :live_view

  alias PetMeals.Feedings

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Feedings")
      |> assign(:feedings, Feedings.list_feedings())
      |> stream(:feedings, Feedings.list_feedings() |> Enum.reverse())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.button phx-click="random">Random Feeding</.button>
    </div>
    <.header class="mt-6">
      {@page_title}
    </.header>

    <.table id="stream_feedings" rows={@streams.feedings}>
      <:col :let={{_dom_id, feedings}} label="ID">
        {feedings.id}
      </:col>
      <:col :let={{_dom_id, feedings}} label="Brand">
        {feedings.brand}
      </:col>
      <:col :let={{_dom_id, feedings}} label="Flavor">
        {feedings.flavor}
      </:col>
      <:col :let={{_dom_id, feedings}} label="Portion">
        {feedings.portion}
      </:col>
    </.table>
    """
  end

  def handle_event("random", _params, socket) do
    socket = put_flash(socket, :info, "Something happened!")
    random_feeding = Feedings.create_random_feeding(socket.assigns.feedings)
    updated_list = [random_feeding | socket.assigns.feedings]

    socket =
      socket
      |> assign(:feedings, updated_list)
      |> stream_insert(:feedings, random_feeding, at: 0)

    {:noreply, socket}
  end
end
