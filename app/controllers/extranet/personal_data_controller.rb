class Extranet::PersonalDataController < Extranet::ApplicationController
  before_action :load_person

  def edit
    breadcrumb
    add_breadcrumb t('extranet.account.edit_personal_data')
  end

  def update
    if @person.update person_params
      redirect_to account_path, notice: t('extranet.personal_data.updated')
    else
      render :edit
      breadcrumb
      add_breadcrumb t('extranet.account.edit_personal_data')
    end
  end

  private

  def load_person
    @person = current_user.person
    raise CanCan::AccessDenied if @person.nil?
  end

  def person_params
    params.require(:university_person)
          .permit(
            :gender, :birthdate, :summary, :biography,
            :phone_mobile, :phone_mobile_visibility, :phone_professional, :phone_professional_visibility, :phone_personal, :phone_personal_visibility,
            :address, :zipcode, :city, :country, :address_visibility,
            :url,
            :linkedin, :linkedin_visibility, :twitter, :twitter_visibility, :mastodon, :mastodon_visibility
          )
  end

  def breadcrumb
    super
    add_breadcrumb t('extranet.account.my'), account_path
  end
end
