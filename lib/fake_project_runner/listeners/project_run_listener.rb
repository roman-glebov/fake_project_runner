class ProjectRunListener
  include Sneakers::Worker
  from_queue 'run_listener'

  def work(msg)
    message = JSON.parse(msg)
    if message.fetch('action', false) == 'start'
      params = {
        project_id: message['id'],
        cf_project_run_id: message['project_run_id']
      }
      repository.create_with_test_runs(params.merge(test_runs: message['test_ids'].map { |m| { test_id: m } }))
    else
      # Send the signal to TR and update project run status
    end
    ack!
  end

  private

  def repository
    @repository ||= ProjectRunRepository.new
  end
end
