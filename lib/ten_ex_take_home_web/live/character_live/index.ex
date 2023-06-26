defmodule TenExTakeHomeWeb.CharacterLive.Index do
  use TenExTakeHomeWeb, :live_view

  alias TenExTakeHome.Marvel
  alias TenExTakeHome.Marvel.Character

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :characters, Marvel.list_characters())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Character")
    |> assign(:character, Marvel.get_character!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Character")
    |> assign(:character, %Character{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Characters")
    |> assign(:character, nil)
  end

  @impl true
  def handle_info({TenExTakeHomeWeb.CharacterLive.FormComponent, {:saved, character}}, socket) do
    {:noreply, stream_insert(socket, :characters, character)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    character = Marvel.get_character!(id)
    # {:ok, _} = Marvel.delete_character(character)

    {:noreply, stream_delete(socket, :characters, character)}
  end
end
