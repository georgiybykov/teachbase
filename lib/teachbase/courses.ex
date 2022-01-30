defmodule Teachbase.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias Teachbase.Repo

  alias Teachbase.Courses.Lesson
  alias Teachbase.Accounts.User

  @doc """
  Returns the list of lessons.

  ## Examples

      iex> list_lessons()
      [%Lesson{}, ...]

  """
  def list_lessons do
    Repo.all(from l in Lesson, preload: [:teacher, :students])
  end

  @doc """
  Gets a single lessons.

  Raises `Ecto.NoResultsError` if the Lessons does not exist.

  ## Examples

      iex> get_lessons!(123)
      %Lesson{}

      iex> get_lessons!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lessons!(id) do
    Lesson
    |> Repo.get!(id)
    |> Repo.preload([:teacher, :students])
  end

  @doc """
  Creates a lessons.

  ## Examples

      iex> create_lessons(%{field: value})
      {:ok, %Lesson{}}

      iex> create_lessons(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lessons(attrs \\ %{}) do
    %Lesson{}
    |> Lesson.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lessons.

  ## Examples

      iex> update_lessons(lessons, %{field: new_value})
      {:ok, %Lesson{}}

      iex> update_lessons(lessons, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lessons(%Lesson{} = lessons, attrs) do
    lessons
    |> Lesson.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lessons.

  ## Examples

      iex> delete_lessons(lessons)
      {:ok, %Lesson{}}

      iex> delete_lessons(lessons)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lessons(%Lesson{} = lessons) do
    Repo.delete(lessons)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lessons changes.

  ## Examples

      iex> change_lessons(lessons)
      %Ecto.Changeset{data: %Lesson{}}

  """
  def change_lessons(%Lesson{} = lessons, attrs \\ %{}) do
    Lesson.changeset(lessons, attrs)
  end

  @doc """
  Attaches student to a lesson.
  """
  @spec attach_student_to_lesson(lesson :: %Lesson{}, student :: %User{}) :: any()
  def attach_student_to_lesson(lesson, student) do
    lesson
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:students, [student | lesson.students])
    |> Repo.update!()
  end

  @doc """
  Returns a list of students by teacher.
  """
  @spec list_students_by_teacher(teacher :: %User{}) :: any()
  def list_students_by_teacher(teacher) do
    query =
      from lesson in Lesson,
        where: lesson.teacher_id == ^teacher.id,
        join: user in assoc(lesson, :students),
        select: user

    Repo.all(query)
  end

  @doc """
  Returns a list of lessons by attached students count.
  """
  @spec list_lessons_by_students_count(count :: non_neg_integer()) :: any()
  def list_lessons_by_students_count(count) do
    query =
      from lesson in Lesson,
        join: user in assoc(lesson, :students),
        group_by: [lesson.id],
        having: count(user.id) > ^count,
        select: lesson

    Repo.all(query)
  end

  @doc """
  Finds and returns a list of lessons by name.
  """
  @spec list_lessons_by_name(template :: binary()) :: any()
  def list_lessons_by_name(template) do
    query =
      from lesson in Lesson,
        where: like(lesson.name, ^template),
        select: lesson

    Repo.all(query)
  end

  @doc """
  Returns a list of lessons if name or description matches the input text.
  """
  @spec list_lessons_with_text(text :: binary()) :: any()
  def list_lessons_with_text(text) do
    template = "%#{text}%"

    query =
      from lesson in Lesson,
        where: like(lesson.name, ^template) or like(lesson.description, ^template),
        select: lesson

    Repo.all(query)
  end
end
