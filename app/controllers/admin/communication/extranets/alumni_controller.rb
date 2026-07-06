class Admin::Communication::Extranets::AlumniController < Admin::Communication::Extranets::ApplicationController
  def index
    @about = @extranet.about
    @alumni = @extranet.alumni
                       .filter_by(params[:filters], current_language)
    @alumni = filter_by_account(@alumni)
    @alumni = @alumni.alumni
                     .ordered(current_language)

    respond_to do |format|
      format.html {
        @alumni = @alumni.page(params[:page])
        @cohorts_count = @extranet.cohorts.count
        @years_count = @extranet.years.count
        @organizations_count = @extranet.organizations.count
        breadcrumb
        add_breadcrumb Communication::Extranet.human_attribute_name(:feature_alumni)
      }
      format.xlsx {
        @alumni = @alumni.includes(:cohorts)
        filename = "alumni-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
      }
    end
  end

  def send_invitation
    person = @extranet.alumni.find(params[:id])
    unless person.user_id
      ExtranetMailer.invitation_message(@extranet, person).deliver_later
      person.update_column(:invitation_sent_at, Time.current)
      redirect_to admin_communication_extranet_alumni_path(@extranet), 
                  notice: t('admin.communication.extranet.alumni.send_invitation.just_sent', name: person.to_s_in(current_language))
    else
      redirect_to admin_communication_extranet_alumni_path(@extranet), 
                  alert: t('admin.communication.extranet.alumni.already_active')
    end
  end

  private

  # This filter can't live in the Filterable scopes because it needs the extranet context.
  def filter_by_account(alumni)
    with_account = params.dig(:filters, :for_alumni_account)
    return alumni if with_account.blank?

    people_with_account = University::Person.where(user_id: @extranet.users.select(:id)).select(:id)
    if ActiveModel::Type::Boolean.new.cast(with_account)
      alumni.where(id: people_with_account)
    else
      alumni.where.not(id: people_with_account)
    end
  end
end