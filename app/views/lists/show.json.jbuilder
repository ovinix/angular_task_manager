json.extract! @list, :id, :user_id, :title, :created_at, :updated_at
json.tasks (@list.tasks) do |task|
  	json.extract! task, :id, :user_id, :list_id, :content, :deadline_at, :priority, :created_at
  	json.done task.completed?
end
