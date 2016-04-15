class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user
  before_action :set_comment, except: [:create]

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to root_path, notice: 'Comment was successfully created.' }
        format.js
      else
        format.html { redirect_to root_path, alert: 'Invalid comment.' }
        format.js
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Comment was successfully destroyed.' }
      format.js
    end
  end

  private
    def correct_user
      @task = current_user.tasks.find_by(id: params[:task_id])
      redirect_to root_path if cannot? :manage, @task
    end

    def set_comment
      @comment = @task.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content, :file)
    end
end
