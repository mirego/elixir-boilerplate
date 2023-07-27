defmodule ElixirBoilerplateGraphQL.Planning.Types do
  use Absinthe.Schema.Notation

  object :project do
    @desc "A sample project"
    field(:id, :id)
    field(:title, :string)
    field(:description, :string)
    field(:launch_at, :datetime)
    field(:tasks, list_of(:task))
  end

  object :task do
    @desc "A sample task"
    field(:id, :id)
    field(:description, :string)
    field(:priority, :integer)
    field(:due_at, :datetime)
  end

  object :planning_queries do
    @desc "A list of projects"
    field :projects, list_of(:project) do
      resolve(fn _parent, _args, _resolution -> ElixirBoilerplate.Planning.list() end)
    end

    @desc "A project"
    field :project, :project do
      arg(:id, :id)
      resolve(fn _parent, %{id: id}, _resolution -> ElixirBoilerplate.Planning.get(id) end)
    end
  end
end
