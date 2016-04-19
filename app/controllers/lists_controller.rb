class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def index
    @lists = current_user.lists.unscoped if current_user
  end

  def show
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json
    end
  end

  def create
    @list = current_user.lists.build(list_params)
    respond_to do |format|
      if @list.save
        format.html { redirect_to root_path }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { redirect_to root_path, alert: 'Invalid list.' }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to root_path }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { redirect_to root_path, alert: 'Invalid list.' }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Confirms the correct user.
    def correct_user
      @list = current_user.lists.find_by(id: params[:id])
      if cannot? :manage, @list
        respond_to do |format|
          format.html { redirect_to root_path  }
          format.json { render json: { error: "Error" }, status: :bad_request }
        end
      end
    end

    def list_params
      params.require(:list).permit(:title)
    end
end
