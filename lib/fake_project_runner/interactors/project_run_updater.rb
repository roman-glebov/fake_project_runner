require 'hanami/interactor'

class ProjectRunUpdater
  include Hanami::Interactor

  expose :message, :routing_key, :error_routing_key

  def initialize(repository: ProjectRunRepository.new)
    @repository = repository
    @routing_key = 'fake_project_runner.project_run.update'
    @error_routing_key = 'fake_project_runner.project_run.update.error'
  end

  def call(attributes)
    @message = @repository.update(attributes['project_run_id'],
                                  status: status(attributes),
                                  completion: completion(attributes),
                                  active_tests: active_tests(attributes)).to_h.to_json
  rescue StandardError => e
    error e.message
  end

  private

  def status(attributes)
    test_runs_statuses(attributes).all? { |status| %w(finished failed).include?(status.to_s) } ? 'finished' : 'running'
    if test_runs_statuses(attributes).all? { |status| %w(finished failed).include?(status.to_s) }
      'finished'
    elsif test_runs_statuses(attributes).include?('stopped')
      'stopped'
    else
      'running'
    end
  end

  def active_tests(attributes)
    test_runs_statuses(attributes).select { |status| status == 'running' }.count
  end

  def completion(attributes)
    "#{finished_tests(attributes).count}/#{test_runs(attributes).count}"
  end

  def finished_tests(attributes)
    test_runs_statuses(attributes).select { |status| %w(finished failed).include?(status.to_s) }
  end

  def test_runs(attributes)
    @test_runs ||= @repository.find_with_test_runs(attributes['project_run_id']).test_runs
  end

  def test_runs_statuses(attributes)
    @test_runs_statuses ||= test_runs(attributes).map(&:status)
  end
end
