class Admin::Communication::Extranets::AlumniController < Admin::Communication::Extranets::ApplicationController
  def index
    @about = @extranet.about
    @alumni = @extranet.alumni
                       .filter_by(params[:filters], current_language)
                       .for_alumni_account(params.dig(:filters, :for_alumni_account), @extranet)
                       .alumni
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
end