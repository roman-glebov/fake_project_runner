require 'hanami/interactor'

class TestRunUpdater
  include Hanami::Interactor

  expose :message, :routing_key, :error_routing_key

  def initialize(repository: TestRunRepository.new)
    @repository = repository
    @routing_key = 'fake_project_runner.test_run.update'
    @error_routing_key = 'fake_project_runner.test_run.update.error'
  end

  def call(attributes)
    @message = @repository.update(attributes['pr_test_run_id'], status: attributes['status']).to_h.to_json
  rescue StandardError => e
    error e.message
  end
end
