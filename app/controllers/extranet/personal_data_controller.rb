class Extranet::PersonalDataController < Extranet::ApplicationController
  before_action :load_person

  def show
    # Superadmins don't have a person
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('extranet.personal_data.edit')
  end

  def update
    @person.update person_params
    redirect_to personal_data_path, notice: t('extranet.personal_data.updated')
  end

  private

  def load_person
    @person = current_user.person
    raise CanCan::AccessDenied if @person.nil?
  end

  def person_params
    params.require(:university_person)
          .permit(
            :gender, :birthdate, :description_short, :biography,
            :phone_mobile, :phone_professional, :phone_personal,
            :address, :zipcode, :city, :country,
            :url, :linkedin, :twitter
          )
  end

  def breadcrumb
    super
    add_breadcrumb t('extranet.personal_data.title'), personal_data_path
  end
end
