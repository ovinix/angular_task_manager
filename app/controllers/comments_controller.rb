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
        format.json { render :show, status: :created }
      else
        format.html { redirect_to root_path, alert: 'Invalid comment.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def correct_user
      @task = current_user.tasks.find_by(id: params[:task_id])
      if cannot? :manage, @task
        respond_to do |format|
          format.html { redirect_to root_path  }
          format.json { render json: { error: "Error" }, status: :bad_request }
        end
      end
    end

    def set_comment
      @comment = @task.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content, :file)
    end
end
