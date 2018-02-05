require 'hanami/interactor'

class ProjectRunStopper
  include Hanami::Interactor

  expose :message, :routing_key, :error_routing_key

  def initialize(repository: ProjectRunRepository.new)
    @repository = repository
    @routing_key = 'fake_project_runner.project_run.stop'
    @error_routing_key = 'fake_project_runner.project_run.stop.error'
  end

  def call(attributes)
    project_run = @repository.find_by_cf_project_run_id(attributes['project_run_id'])
    test_run_ids = @repository.find_with_test_runs(project_run.id).test_runs.map(&:id)
    @message = { test_run_ids: test_run_ids }.to_json
  rescue StandardError => e
    error e.message
  end
end
