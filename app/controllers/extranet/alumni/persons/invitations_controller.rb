class Extranet::Alumni::Persons::InvitationsController < Extranet::Alumni::ApplicationController

  before_action :find_person, :ensure_person_is_invitable

  def new
    @invitation = current_extranet.invitations.build(
      from_name: current_user.to_s,
      from_email: current_user.email,
      to_name: @l10n.to_s,
      to_email: @person.email,
      message: "TODO: Add a default message for the invitation"
    )
    breadcrumb
  end

  def create
    @invitation = current_extranet.invitations.build(invitation_params)
    if @invitation.save
      redirect_to [:alumni, @person], notice: t('extranet.alumni.invitations.created')
    else
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  protected

  def invitation_params
    params.require(:communication_extranet_invitation)
          .permit(:from_name, :from_email, :to_name, :to_email, :message)
          .merge(
            user_id: current_user.id,
            person_id: @person.id,
            university_id: current_university.id
          )
  end

  def breadcrumb
    super
    add_breadcrumb University::Person.model_name.human(count: 2), alumni_university_persons_path
    add_breadcrumb @l10n, alumni_university_person_path(@person)
    add_breadcrumb t('extranet.alumni.invitations.title')
  end

  def find_person
    @person = current_extranet.about.university_person_alumni.find(params[:id])
    @l10n = @person.best_localization_for(current_language)
  end

  def ensure_person_is_invitable
    unless Communication::Extranet::Invitation.sendable_to?(@person)
      redirect_to [:alumni, @person], alert: t('extranet.alumni.invitations.send.too_soon')
    end
  end
  
end
