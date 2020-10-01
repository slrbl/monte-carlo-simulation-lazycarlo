class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    redirect_to projects_path
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new(project_id:params[:project_id])
    @projects_list = get_projects_list
  end

  # GET /tasks/1/edit
  def edit
    @projects_list = get_projects_list
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    # Calculate man and standard deviation



    respond_to do |format|
      if @task.save
        format.html { redirect_to @task.project, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to @task.project, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_projects_list
    @projects_list = []
    Project.all.each do |project|
      @projects_list << [project.name,project.id]
    end
    return @projects_list
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :description,:project_id,:duration_lb,:duration_ub,:cost_lb,:cost_ub,:stdrd_deviation,:mean,:metric_one_label,:metric_two_label)
    end
end
