json.extract! @task, :id, :user_id, :list_id, :content, :deadline_at, :priority
json.done @task.completed?