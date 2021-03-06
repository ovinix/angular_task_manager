json.array!(@lists) do |list|
  json.extract! list, :id, :user_id, :title
  json.url list_url(list, format: :json)
  json.tasks (list.tasks) do |task|
  	json.extract! task, :id, :user_id, :list_id, :content, :completed_at, :priority, :deadline_at, :created_at
  	json.done task.completed?
  end
end
