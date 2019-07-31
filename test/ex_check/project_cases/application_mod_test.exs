defmodule ExCheck.ProjectCases.ApplicationModTest do
  use ExCheck.ProjectCase, async: true

  @application """
  defmodule TestProject.Application do
    use Application

    def start(_type, _args) do
      children = []

      opts = [strategy: :one_for_one, name: ExCheck.Supervisor]

      if Mix.env() != :test do
        raise("running app during check!")
      end

      Supervisor.start_link(children, opts)
    end
  end
  """

  test "application mod", %{project_dir: project_dir} do
    set_mix_app_mod(project_dir, "TestProject.Application")

    application_path = Path.join([project_dir, "lib", "application.ex"])
    File.write!(application_path, @application)

    assert {output, 0} = System.cmd("mix", ~w[check], cd: project_dir)

    assert String.contains?(output, "compiler success")
    assert String.contains?(output, "formatter success")
    assert String.contains?(output, "ex_unit success")
  end
end