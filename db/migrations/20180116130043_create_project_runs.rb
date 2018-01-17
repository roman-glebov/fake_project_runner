Hanami::Model.migration do
  change do
    create_table :project_runs do
      primary_key :id

      column :project_id, Integer, null: false
      column :cf_project_run_id, Integer, null: false, unique: true
      column :status, String, null: false, default: 'starting'
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
