class EventRegister
  include Dry::Events::Publisher[:fake_project_runner_publisher]
  ROUTING_COLLECTION = %w(
    fake_cf_api.project_run.start
    fake_cf_api.project_run.stop
    fake_project_runner.test_run.update
    fake_test_runner.test_run.update
  ).freeze

  ROUTING_COLLECTION.each do |routing|
    register_event(routing)
  end
end
