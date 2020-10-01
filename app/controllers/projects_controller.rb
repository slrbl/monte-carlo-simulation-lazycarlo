class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    if current_user.is_admin
      @projects = Project.all
    else
      @projects = current_user.projects
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    # Monte Carlo Simulation
    if params[:epochs] == nil or params[:epochs].to_i == 0
      @epochs = 1000
    else
      @epochs = params[:epochs].to_i
      if @epochs>5000
        @epochs=5000
      end
    end
    if params[:dist] == nil or params[:dist] == ""
      dist='normal'
    else
      dist=params[:dist]
    end

    simulate(@project,@epochs,dist)
  end

  # GET /projects/new
  def new
    @project = Project.new()
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  protected

  def simulate(project,epochs,dist)

    @dur_simulation = []
    @dur_sim_freq = {}
    @dur_sim_freq_cumul = {}
    @cost_simulation = []
    @cost_sim_freq = {}
    @cost_sim_freq_cumul = {}
    dur_simulations_params=[]
    cost_simulations_params=[]
    for i in 1..epochs
      current_dur_simulation_params={}
      current_dur_simulation_params['tasks']=[]
      current_cost_simulation_params={}
      current_cost_simulation_params['tasks']=[]
      current_dur_simulation = 0
      min_dur=0
      max_dur=0
      current_cost_simulation = 0
      min_cost=0
      max_cost=0
      take_number=0
      project.tasks.each do |task|
        task.duration_lb = 0 unless task.duration_lb != nil
        task.duration_ub = 0 unless task.duration_ub != nil
        task.cost_ub = 0 unless task.cost_ub != nil
        task.cost_lb = 0 unless task.cost_lb != nil

        take_number+=1
        if dist == 'uniform'
          current_dur_simulation += rand(task.duration_lb..task.duration_ub)
          current_cost_simulation += rand(task.cost_lb..task.cost_ub)
        elsif dist == 'normal'
          dur_mean = (task.duration_lb + task.duration_ub) / 2
          cost_mean = (task.cost_lb + task.cost_ub) / 2
          dur_stdrd_dev = (task.duration_ub - task.duration_lb) / 3.29
          cost_stdrd_dev = (task.cost_ub - task.cost_lb) / 3.29
          current_dur_simulation_params['tasks'] << {'mean':dur_mean,'stdr_dev':dur_stdrd_dev,'prob':rand}
          current_cost_simulation_params['tasks'] << {'mean':cost_mean,'stdr_dev':cost_stdrd_dev,'prob':rand}
        end

        min_dur += task.duration_lb
        max_dur += task.duration_ub
        min_cost += task.cost_lb.to_i
        max_cost += task.cost_ub.to_i

      end
      if dist == 'normal'
        dur_simulations_params.append(current_dur_simulation_params)
        cost_simulations_params.append(current_cost_simulation_params)
      elsif dist == 'uniform'
        @dur_simulation << current_dur_simulation.to_i
        @cost_simulation << current_cost_simulation.to_i
      end
    end

    if dist=='normal'
      #  write the json params to a json file
      dur_param_file_name = "tmp/simulation_params/"+Time.now.to_i.to_s+"_dur_"+current_user.id.to_s+'.json'
      File.open(dur_param_file_name, "w") { |f| f.write dur_simulations_params.to_json.to_s }

    #cmd = "python3.8 norm_inv.py '"+dur_simulations_params.to_json.to_s+"'"
    cmd = "python3.8 norm_inv.py "+dur_param_file_name
    result = `#{cmd}`
    result_array=result.split(',')
    result_array.each do |value|
      @dur_simulation << value.to_i
    end

    cost_param_file_name = "tmp/simulation_params/"+Time.now.to_i.to_s+"_cost_"+current_user.id.to_s+'.json'
    File.open(cost_param_file_name, "w") { |f| f.write cost_simulations_params.to_json.to_s }
    cmd = "python3.8 norm_inv.py "+cost_param_file_name
    result = `#{cmd}`
    result_array=result.split(',')
    result_array.each do |value|
      @cost_simulation << value.to_i
    end

    end

    for i in (min_dur..max_dur).step(1)
      @dur_sim_freq[i]=@dur_simulation.count(i)*100/@dur_simulation.length.to_d
      #@cost_sim_freq[i]=@cost_simulation.count(i)
    end
    for i in (min_cost..max_cost).step(1)
      @cost_sim_freq[i]=@cost_simulation.count(i)*100/@cost_simulation.length.to_d
    end

    i = 0
    cumul=0
    @dur_sim_freq.each do |dur,freq|
      if (i != 0)
        cumul+= freq unless i == 0
        @dur_sim_freq_cumul[dur] = cumul
      else
        @dur_sim_freq_cumul[dur] = freq
      end
      i+=1
    end


    i = 0
    cumul=0
    @cost_sim_freq.each do |cost,freq|
      if (i != 0)
        cumul+= freq unless i == 0
        @cost_sim_freq_cumul[cost] = cumul
      else
        @cost_sim_freq_cumul[cost] = freq
      end
      i+=1
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :description,:metric_one_label,:metric_two_label,:user_id)
    end
end
