Hanami::Model.migration do
  up do
    add_column :project_runs, :completion, String
  end

  down do
    drop_column :project_runs, :completion
  end
end
