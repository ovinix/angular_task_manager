json.extract! @task, :id, :user_id, :list_id, :content, :deadline_at, :priority, :created_at
json.done @task.completed?
json.comments (@task.comments) do |comment|
	json.extract! comment, :id, :content, :created_at
	json.user_name comment.user.name
	if comment.file?
		json.file do
			json.url comment.file.url
			if Rails.env.production?
				json.name comment.file.public_id
			else
				json.name comment.file.file.filename
			end
		end
	end
end