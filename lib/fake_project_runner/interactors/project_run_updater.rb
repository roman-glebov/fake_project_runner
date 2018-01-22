require 'hanami/interactor'

class ProjectRunUpdater
  include Hanami::Interactor

  expose :project_run

  def initialize(repository: ProjectRunRepository.new)
    @repository = repository
  end

  def call(attributes)
    @project_run = @repository.update(attributes['project_run_id'],
                                      status: status(attributes),
                                      active_tests: active_tests(attributes))
  rescue StandardError => e
    error e.message
  end

  private

  def status(attributes)
    test_runs_statuses(attributes).all? { |status| %[finished failed].include?(status.to_s) } ? 'finished' : 'running'
  end

  def active_tests(attributes)
    test_runs_statuses(attributes).select { |status| status == 'running' }.count
  end

  def test_runs_statuses(attributes)
    @test_runs_statuses ||=
      @repository.find_with_test_runs(attributes['project_run_id']).test_runs.map { |test_run| test_run.status }
  end
end
