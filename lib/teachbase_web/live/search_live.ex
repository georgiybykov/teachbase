defmodule TeachbaseWeb.SearchLive do
  use TeachbaseWeb, :live_view

  alias Teachbase.Courses

  def mount(_params, _session, socket) do
    {:ok, assign(socket, text: "", lessons: [])}
  end

  def handle_event("search", %{"text" => text}, socket) do
    case text do
      "" ->
        {:noreply, assign(socket, text: text, lessons: [])}

      text ->
        {:noreply, assign(socket, text: text, lessons: Courses.list_lessons_with_text(text))}
    end
  end
end
