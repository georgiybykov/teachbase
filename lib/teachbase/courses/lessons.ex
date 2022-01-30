defmodule Teachbase.Courses.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  alias Teachbase.Accounts.User

  schema "lessons" do
    field :description, :string
    field :name, :string
    field :reference, :string

    belongs_to :teacher, User
    many_to_many :students, User, join_through: "lessons_students"

    timestamps()
  end

  @doc false
  def changeset(lessons, attrs) do
    lessons
    |> cast(attrs, [:name, :description, :reference])
    |> cast_assoc(:teacher, with: &User.registration_changeset/2)
    |> validate_required([:name, :description, :reference, :teacher])
  end
end
