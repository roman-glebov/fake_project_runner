class TestRunUpdaterListener
  include Sneakers::Worker
  from_queue 'fake_test_runner.test_run.update'

  def work(msg)
    message = JSON.parse(msg)
    result = TestRunUpdater.new.call(message)
    if result.successful?
      Sneakers.publish(result.test_run.to_h.to_json, routing_key: 'fake_project_runner.test_run.update')
    else
      Sneakers.publish(result.error, routing_key: 'fake_project_runner.test_run.update.error')
    end
    ack!
  end
end
