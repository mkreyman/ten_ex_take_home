defmodule TenExTakeHomeWeb.CharacterLive.FormComponent do
  use TenExTakeHomeWeb, :live_component

  # alias TenExTakeHome.Marvel

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage character records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="character-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Character</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{character: _character} = _assigns, socket) do
    # changeset = Marvel.change_character(character)

    # {:ok,
    #  socket
    #  |> assign(assigns)
    #  |> assign_form(changeset)}

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"character" => _character_params}, socket) do
    # changeset =
    #   socket.assigns.character
    #   |> Marvel.change_character(character_params)
    #   |> Map.put(:action, :validate)

    # {:noreply, assign_form(socket, changeset)}

    {:noreply, socket}
  end

  def handle_event("save", %{"character" => character_params}, socket) do
    save_character(socket, socket.assigns.action, character_params)
  end

  defp save_character(socket, :edit, _character_params) do
    # case Marvel.update_character(socket.assigns.character, character_params) do
    #   {:ok, character} ->
    #     notify_parent({:saved, character})

    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Character updated successfully")
    #      |> push_patch(to: socket.assigns.patch)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign_form(socket, changeset)}
    # end

    {:noreply, socket}
  end

  defp save_character(socket, :new, _character_params) do
    # case Marvel.create_character(character_params) do
    #   {:ok, character} ->
    #     notify_parent({:saved, character})

    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Character created successfully")
    #      |> push_patch(to: socket.assigns.patch)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign_form(socket, changeset)}
    # end

    {:noreply, socket}
  end

  # defp assign_form(socket, %Ecto.Changeset{} = changeset) do
  #   assign(socket, :form, to_form(changeset))
  # end

  # defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
