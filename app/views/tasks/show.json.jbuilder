json.extract! @task, :id, :user_id, :list_id, :content, :deadline_at, :priority, :created_at
json.done @task.completed?