class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def index
    @lists = current_user.lists if current_user
  end

  def show
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json
    end
  end

  def new
    @list = current_user.lists.build
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def create
    @list = current_user.lists.build(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to root_path }
        format.js
        format.json { render :show, status: :created, location: @list }
      else
        format.html { redirect_to root_path, alert: 'Invalid list.' }
        format.js
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to root_path }
        format.js
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { redirect_to root_path, alert: 'Invalid list.' }
        format.js
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'List was successfully destroyed.' }
      format.js
      format.json { head :no_content }
    end
  end

  private
    # Confirms the correct user.
    def correct_user
      @list = current_user.lists.find_by(id: params[:id])
      redirect_to root_path if cannot? :manage, @list
    end

    def list_params
      params.require(:list).permit(:title)
    end
end
