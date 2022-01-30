defmodule Teachbase.Repo.Migrations.CreateLessonsStudents do
  use Ecto.Migration

  def change do
    create table(:lessons_students) do
      add :lesson_id, references(:lessons)
      add :user_id, references(:users)
    end

    create unique_index(:lessons_students, [:lesson_id, :user_id])
  end
end
