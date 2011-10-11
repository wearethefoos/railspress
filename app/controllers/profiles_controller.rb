class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    if not current_user.profile.present?
      current_user.profile = Profile.new
    end
    if not current_user.profile.image.present?
      current_user.profile.build_image
    end
    if not current_user.name.blank? and not current_user.profile.name.present?
      current_user.profile.name = current_user.name
      current_user.profile.user_id = current_user.id
      current_user.profile.save
    end
    @profile = current_user.profile
  end

  # POST /profiles
  # POST /profiles.json
  def create
    if not current_user.profile.present?
      current_user.profile = Profile.new(params[:profile])

      respond_to do |format|
        if current_user.profile.save
          format.html { redirect_to current_user.profile, notice: 'Profile was successfully created.' }
          format.json { render json: current_user.profile, status: :created, location: current_user.profile }
        else
          format.html { render action: "new" }
          format.json { render json: current_user.profile.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :ok }
    end
  end
end
