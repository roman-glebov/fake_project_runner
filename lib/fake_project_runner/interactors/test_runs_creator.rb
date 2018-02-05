require 'hanami/interactor'

class TestRunsCreator
  include Hanami::Interactor

  expose :message, :routing_key, :error_routing_key

  def initialize(repository: ProjectRunRepository.new)
    @repository = repository
    @routing_key = 'fake_project_runner.test_runs.start'
    @error_routing_key = 'fake_project_runner.test_runs.start.error'
  end

  def call(attributes)
    project_run_params = {
      project_id: attributes['id'],
      cf_project_run_id: attributes['project_run_id']
    }
    project_run =
      @repository.create_with_test_runs(project_run_params.merge(test_runs: test_runs_data(attributes)))
    @message = project_run.test_runs.map(&:to_h).to_json
  rescue StandardError => e
    error e.message
  end

  private

  def test_runs_data(attributes)
    attributes['test_ids'].map { |m| { test_id: m } }
  end
end
