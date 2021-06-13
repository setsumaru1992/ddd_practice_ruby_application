class Debug::Person::GroupsController < ApplicationController
  # GET /debug/person/groups
  # GET /debug/person/groups.json
  def index
    @groups = ::PersonGroup.all
  end

  # GET /debug/person/groups/1
  # GET /debug/person/groups/1.json
  def show
  end

  # GET /debug/person/groups/new
  def new
    @person_group = ::PersonGroup.new
    @parent_group_candidates = parent_group_candidates
    @parent_group_id_param = params[:parent_group_id_param]
  end

  # GET /debug/person/groups/1/edit
  def edit
    @person_group = ::PersonGroup.find(params[:id])
    @parent_group_candidates = parent_group_candidates
    @parent_group_id_param = @person_group.parent&.id_param
  end

  # POST /debug/person/groups
  # POST /debug/person/groups.json
  def create
    ::Domain::Person::Group::Command::CreateCommand.call(
      name: person_group_params[:name],
      accessible_user_id_param: current_access_user_id_param,
      parent_group_id_param: person_group_params[:parent_group_id_param]
    )

    redirect_to debug_person_groups_path, notice: 'Group was successfully created.'
  end

  # PATCH/PUT /debug/person/groups/1
  # PATCH/PUT /debug/person/groups/1.json
  def update
    ::Domain::Person::Group::Command::UpdateCommand.call(
      id_param: person_group_params[:id_param],
      name: person_group_params[:name],
      parent_group_id_param: person_group_params[:parent_group_id_param]
    )

    redirect_to debug_person_groups_path, notice: 'Group was successfully updated.'
  end

  # DELETE /debug/person/groups/1
  # DELETE /debug/person/groups/1.json
  def destroy
    result = ::Domain::Person::Group::Command::RemoveCommand.call(
      id_param: person_group_params[:id_param],
    )

    if result.success?
      redirect_to debug_person_groups_path, notice: 'Group was successfully removed.'
    else
      redirect_to debug_person_groups_path, notice: result.error_message
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def person_group_params
      params.fetch(:person_group, {}).permit(:id_param, :name, :parent_group_id_param)
    end

    def parent_group_candidates
      [["--", nil]].concat(::Domain::Person::Group::Finder::BuildIdParamAndLabelSetsForSelectbox.call(
        access_user_id: current_access_user_id,
        limit_layer_depth: 2
      ))
    end

    def current_access_user_id_param
       # TODO: 現在固定のため、将来的に任意に選べるよう修正。このメソッド自体も使わなくていいように
      "Em5GnK8ws55nRM4m"
    end

    def current_access_user_id
       # TODO: 現在固定のため、将来的に任意に選べるよう修正。このメソッド自体も使わなくていいように
      1
    end
end
