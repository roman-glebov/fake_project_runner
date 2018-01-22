class ProjectRunStartListener
  include Sneakers::Worker
  from_queue 'fake_cf_api.project_run.start'

  def work(msg)
    message = JSON.parse(msg)
    params = {
      project_id: message['id'],
      cf_project_run_id: message['project_run_id']
    }
    project_run =
      repository.create_with_test_runs(params.merge(test_runs: message['test_ids'].map { |m| { test_id: m } }))
    Sneakers.publish(project_run.test_runs.map(&:to_h).to_json,
                     routing_key: 'fake_project_runner.test_runs.start')
    ack!
  end

  private

  def repository
    @repository ||= ProjectRunRepository.new
  end
end
