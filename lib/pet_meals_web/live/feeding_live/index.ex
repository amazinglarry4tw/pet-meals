defmodule PetMealsWeb.FeedingLive.Index do
  use PetMealsWeb, :live_view

  alias PetMeals.Feedings
  alias Calendar

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Feedings")
      |> assign(:feedings, Feedings.list_feedings())
      |> assign(:selected_brand, nil)
      |> assign(:selected_flavor, nil)
      |> assign(:selected_portion, nil)
      |> assign(:brands, ["Sheba", "Fancy Feast", "Blue Buffalo"])
      |> assign(:flavors, ["Beef", "Salmon", "Turkey"])
      |> assign(:portions, ["full", "half", "quarter"])
      |> stream(:feedings, Feedings.list_feedings())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.button
      class="my-2"
      phx-click={
        JS.toggle(
          to: "#add_feedings",
          in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
          out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
          time: 300
        )
      }
    >
      Add Feeding
    </.button>
    <div id="add_feedings" class="add_feedings hidden">
      <form phx-submit="add_feeding" phx-change="form_change">
        <div class="brand-row">
          <div class="options">
            <%= for brand <- @brands do %>
              <div
                class={["option", @selected_brand == brand && "selected"]}
                phx-click="select_brand"
                phx-value-brand={brand}
              >
                {brand}
              </div>
            <% end %>
          </div>
        </div>

        <div class="flavor-row">
          <div class="options">
            <%= for flavor <- @flavors do %>
              <div
                class={["option", @selected_flavor == flavor && "selected"]}
                phx-click="select_flavor"
                phx-value-flavor={flavor}
              >
                {flavor}
              </div>
            <% end %>
          </div>
        </div>

        <div class="portions-row">
          <div class="options">
            <%= for portion <- @portions do %>
              <div
                class={["option", @selected_portion == portion && "selected"]}
                phx-click="select_portion"
                phx-value-portion={portion}
              >
                {portion}
              </div>
            <% end %>
          </div>
        </div>

        <button
          type="submit"
          class="submit-btn"
          disabled={is_nil(@selected_brand) || is_nil(@selected_flavor) || is_nil(@selected_portion)}
          phx-click={
            JS.toggle(
              to: "#add_feedings",
              in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
              out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
              time: 300
            )
          }
        >
          Submit
        </button>
      </form>
    </div>

    <.header class="mt-6">
      {@page_title}
    </.header>

    <div class="feedings flex flex-col-reverse" id="feedings" phx-update="stream">
      <.feeding_card :for={{_dom_id, feeding} <- @streams.feedings} feedings={feeding} />
    </div>
    """
  end

  def feeding_card(assigns) do
    ~H"""
    <div class="card">
      <div class="flex-1">
        <div class="details">
          <div class="detail">
            {display_flavor(@feedings.flavor)}
          </div>
          <span class="brand-pill" data-brand={@feedings.brand}>
            {@feedings.brand}
          </span>
          <div class="detail">{@feedings.portion}</div>
        </div>
        <div class="timestamp">{@feedings.time}</div>
      </div>
    </div>
    """
  end

  defp display_flavor("Beef"), do: "🥩"
  defp display_flavor("Chicken"), do: "🍗"
  defp display_flavor("Turkey"), do: "🦃"
  defp display_flavor("Salmon"), do: "🐟"
  defp display_flavor(_), do: "🍴"

  def handle_event("select_brand", %{"brand" => brand}, socket) do
    {:noreply, assign(socket, :selected_brand, brand)}
  end

  def handle_event("select_flavor", %{"flavor" => flavor}, socket) do
    {:noreply, assign(socket, :selected_flavor, flavor)}
  end

  def handle_event("select_portion", %{"portion" => portion}, socket) do
    {:noreply, assign(socket, :selected_portion, portion)}
  end

  def handle_event(
        "form_change",
        %{"brand" => brand, "flavor" => flavor, "portion" => portion},
        socket
      ) do
    socket =
      socket
      |> assign(:selected_brand, (brand == "" && nil) || brand)
      |> assign(:selected_flavor, (flavor == "" && nil) || flavor)
      |> assign(:selected_portion, (portion == "" && nil) || portion)

    {:noreply, socket}
  end

  def handle_event("add_feeding", _params, socket) do
    case {socket.assigns.selected_brand, socket.assigns.selected_flavor,
          socket.assigns.selected_portion} do
      {nil, _, _} ->
        {:noreply, put_flash(socket, :error, "Please select a brand")}

      {_, nil, _} ->
        {:noreply, put_flash(socket, :error, "Please select a flavor")}

      {_, _, nil} ->
        {:noreply, put_flash(socket, :error, "Please select a portion")}

      {brand, flavor, portion} ->
        feeding = Feedings.create_feeding(socket.assigns.feedings, brand, flavor, portion)
        feedings = [feeding | socket.assigns.feedings]

        socket =
          socket
          |> assign(:feedings, feedings)
          |> assign(:selected_brand, nil)
          |> assign(:selected_flavor, nil)
          |> assign(:selected_portion, nil)
          |> stream_insert(:feedings, feeding, at: -1)

        {:noreply, socket}
    end
  end
end
