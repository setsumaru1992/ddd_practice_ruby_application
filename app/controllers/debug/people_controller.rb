class Debug::PeopleController < ApplicationController
  def root
  end

  # GET /debug/people
  # GET /debug/people.json
  def index
    @people = ::Person.all
  end

  # GET /debug/people/1
  # GET /debug/people/1.json
  def show
  end

  # GET /debug/people/new
  def new
    @person = ::Person.new
    @group_candidates = group_candidates
  end

  # GET /debug/people/1/edit
  def edit
    @person = ::Person.find(params[:id])
    @group_candidates = group_candidates
  end

  # POST /debug/people
  # POST /debug/people.json
  def create
    ::Domain::Person::Command::CreateCommand.call(
      disp_name: person_params[:name][:disp_name],
      first_name: person_params[:name][:first_name],
      last_name: person_params[:name][:last_name],
      middle_name: person_params[:name][:middle_name],
      kana: person_params[:name][:kana],
      birth_sex_code: person_params[:sex][:birth_sex_code],
      desired_sex_code: person_params[:sex][:desired_sex_code],
      birth_year: person_params[:birthdate][:year],
      birth_month: person_params[:birthdate][:month],
      birth_date: person_params[:birthdate][:date],
      belonging_person_group_id_param: person_params[:person_group].fetch(:id_param, nil),
      accessible_user_id_param: current_access_user_id_param,
    )
    redirect_to debug_people_path, notice: 'Group was successfully created.'
  end

  # PATCH/PUT /debug/people/1
  # PATCH/PUT /debug/people/1.json
  def update
    ::Domain::Person::Command::UpdateCommand.call(
      id_param: person_params[:id_param],
      disp_name: person_params[:name][:disp_name],
      first_name: person_params[:name][:first_name],
      last_name: person_params[:name][:last_name],
      middle_name: person_params[:name][:middle_name],
      kana: person_params[:name][:kana],
      birth_sex_code: person_params[:sex][:birth_sex_code],
      desired_sex_code: person_params[:sex][:desired_sex_code],
      birth_year: person_params[:birthdate][:year],
      birth_month: person_params[:birthdate][:month],
      birth_date: person_params[:birthdate][:date],
      belonging_person_group_id_param: person_params[:person_group].fetch(:id_param, nil),
    )
    redirect_to debug_people_path, notice: 'Group was successfully updated.'
  end

  # DELETE /debug/people/1
  # DELETE /debug/people/1.json
  def destroy
    ::Domain::Person::Command::RemoveCommand.call(
      id_param: person_params[:id_param],
    )
    redirect_to debug_people_path, notice: 'Group was successfully removed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # Only allow a list of trusted parameters through.
    def person_params
      params.fetch(:person, {}).permit(
        :id_param,

        {
          name: [
            :disp_name,
            :first_name,
            :last_name,
            :middle_name,
            :kana,
          ],

          sex: [
            :birth_sex_code,
            :desired_sex_code,
          ],
          
          birthdate: [
            :year,
            :month,
            :date,
          ],
          
          person_group: [
            :id_param
          ],
        }
      )
    end

    def group_candidates
      [["--", nil]].concat(::Domain::Person::Group::Finder::BuildIdParamAndLabelSetsForSelectbox.call(
        access_user_id: current_access_user_id,
        limit_layer_depth: 3
      ))
    end

    def current_access_user_id_param
       # TODO: 現在固定値を使用しているため将来的に修正必要。動的にアクセスユーザの値を使用するようにし、このメソッド自体も使わなくていいようにする
      "Em5GnK8ws55nRM4m"
    end

    def current_access_user_id
      # TODO: 現在固定値を使用しているため将来的に修正必要。動的にアクセスユーザの値を使用するようにし、このメソッド自体も使わなくていいようにする
      1
    end
end
