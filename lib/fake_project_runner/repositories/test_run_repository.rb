class TestRunRepository < Hanami::Repository
  associations do
    belongs_to :project_run
  end

  def find_with_project_run(id)
    aggregate(:project_run).where(id: id).map_to(TestRun).one
  end
end
