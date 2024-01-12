# frozen_string_literal: true

# Use MySQLDatabaseTasks for Trilogy
ActiveRecord::Tasks::DatabaseTasks.register_task(
  "trilogis",
  "ActiveRecord::Tasks::MySQLDatabaseTasks"
)
