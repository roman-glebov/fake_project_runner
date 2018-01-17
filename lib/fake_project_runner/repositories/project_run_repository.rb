class ProjectRunRepository < Hanami::Repository
  associations do
    has_many :test_runs
  end

  def create_with_test_runs(data)
    assoc(:test_runs).create(data)
  end

  def find_with_test_runs(id)
    aggregate(:test_runs).where(id: id).as(ProjectRun).one
  end
end
