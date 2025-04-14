# app/controllers/empires_controller.rb
class EmpiresController < ApplicationController
  before_action :require_user
  before_action :set_empire, only: [:show, :edit, :update, :update_resources]
  before_action :require_same_user, only: [:show, :edit, :update]

  def show
  end

  def new
    # Check if user already has an empire
    if current_user.empire
      flash[:alert] = "You already have an empire"
      redirect_to empire_path(current_user.empire)
    else
      @empire = Empire.new
    end
  end

  def create
    @empire = Empire.new(empire_params)
    @empire.user = current_user
    
    # Set default resources
    @empire.credits ||= 1000
    @empire.minerals ||= 500
    @empire.energy ||= 200
    @empire.food ||= 300
    @empire.population ||= 100
    
    if @empire.save
      flash[:notice] = "Empire successfully created"
      redirect_to empire_path(@empire)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @empire.update(empire_params)
      flash[:notice] = "Empire successfully updated"
      redirect_to empire_path(@empire)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_resources
    # Simple endpoint for testing resource updates
    if resource_params[:action] == 'add'
      @empire.add_credits(resource_params[:amount].to_i) if resource_params[:resource] == 'credits'
      @empire.add_minerals(resource_params[:amount].to_i) if resource_params[:resource] == 'minerals'
      @empire.add_energy(resource_params[:amount].to_i) if resource_params[:resource] == 'energy'
      @empire.add_food(resource_params[:amount].to_i) if resource_params[:resource] == 'food'
      @empire.add_population(resource_params[:amount].to_i) if resource_params[:resource] == 'population'
    else
      @empire.remove_credits(resource_params[:amount].to_i) if resource_params[:resource] == 'credits'
      @empire.remove_minerals(resource_params[:amount].to_i) if resource_params[:resource] == 'minerals'
      @empire.remove_energy(resource_params[:amount].to_i) if resource_params[:resource] == 'energy'
      @empire.remove_food(resource_params[:amount].to_i) if resource_params[:resource] == 'food'
      @empire.remove_population(resource_params[:amount].to_i) if resource_params[:resource] == 'population'
    end
    
    redirect_to empire_path(@empire), notice: "Resources updated successfully!"
  end

  private

  def empire_params
    params.require(:empire).permit(:name)
  end

  def set_empire
    @empire = Empire.find(params[:id])
  end

  def resource_params
    params.require(:resource_update).permit(:resource, :action, :amount)
  end

  def require_same_user
    if current_user.empire != @empire
      flash[:alert] = "You can only manage your own empire"
      redirect_to root_path
    end
  end
end
