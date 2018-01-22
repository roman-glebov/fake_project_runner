require 'hanami/interactor'

class TestRunUpdater
  include Hanami::Interactor

  expose :test_run

  def initialize(repository: TestRunRepository.new)
    @repository = repository
  end

  def call(attributes)
    @test_run = @repository.update(attributes['pr_test_run_id'], status: attributes['status'])
  rescue StandardError => e
    error e.message
  end
end
