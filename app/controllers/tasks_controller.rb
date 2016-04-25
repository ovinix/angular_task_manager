class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user
  before_action :set_task, except: [:create]

  def show
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json
    end
  end

  def create
    @task = @list.tasks.build(task_params)
    @task.user_id = current_user.id
    respond_to do |format|
      if @task.save
        format.html { redirect_to root_path, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created }
      else
        format.html { redirect_to root_path, alert: 'Invalid task.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to root_path, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok }
      else
        format.html { redirect_to root_path, alert: 'Invalid task.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete
    @task.update_attribute(:completed_at, @task.completed? ? nil : Time.now)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :show, status: :ok }
    end
  end

  def prioritize
    @task.important? ? @task.normal! : @task.important!
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :show, status: :ok }
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def correct_user
      @list = current_user.lists.find_by(id: params[:list_id])
      redirect_to root_path if cannot? :manage, @list
    end

    def set_task
      @task = @list.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:content, :completed_at, :deadline_at, :priority)
    end
end
