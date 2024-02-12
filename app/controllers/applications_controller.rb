class ApplicationsController < ApplicationController

  def create
    @application = Application.new(application_params)
    @application.update(status: 1)
    if @application.save
      redirect_to "/applications/#{@application.id}"
    else
      flash[:notice] = "Error: Application not created: Required information missing."
      redirect_to new_applications_path
    end
  end

  def update
    application = Application.find(params[:id])
    if params[:good_owner_comments].present?
      application.update(application_params)

      redirect_to show_applications_path(application)
    end
  end

  def show
    @application = Application.find(params[:id])
    if params[:pet_name].present?
        @pets = Pet.search(params[:pet_name])
    end
  end

  private
  def application_params
    params.permit(
      :name,
      :street_address,
      :city,
      :state,
      :zipcode,
      :description,
      :status)
  end
end
