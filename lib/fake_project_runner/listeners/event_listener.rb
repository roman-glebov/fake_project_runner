class EventListener
  def on_fake_cf_api_project_run_start(event)
    call_action(TestRunsCreator.new.call(event[:payload]))
  end

  def on_fake_cf_api_project_run_stop(event)
    call_action(ProjectRunStopper.new.call(event[:payload]))
  end

  def on_fake_project_runner_test_run_update(event)
    call_action(ProjectRunUpdater.new.call(event[:payload]))
  end

  def on_fake_test_runner_test_run_update(event)
    call_action(TestRunUpdater.new.call(event[:payload]))
  end

  private

  def call_action(response)
    if response.successful?
      Sneakers.publish(response.message, routing_key: response.routing_key)
    else
      Sneakers.publish(response.error, routing_key: response.error_routing_key)
    end
  end
end
