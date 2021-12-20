class Admin::Administration::MembersController < Admin::Administration::ApplicationController
  load_and_authorize_resource class: Administration::Member,
                              through: :current_university,
                              through_association: :administration_members

  def index
    @members = @members.ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @member.save
      redirect_to admin_administration_member_path(@member), notice: t('admin.successfully_created_html', model: @member.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @member.update(member_params)
      redirect_to admin_administration_member_path(@member), notice: t('admin.successfully_updated_html', model: @member.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member.destroy
    redirect_to admin_administration_members_url, notice: t('admin.successfully_destroyed_html', model: @member.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Administration::Member.model_name.human(count: 2),
                    admin_administration_members_path
    breadcrumb_for @member
  end

  def member_params
    params.require(:administration_member)
          .permit(:first_name, :last_name, :email, :phone, :biography, :slug, :user_id,
          :is_author, :is_researcher, :is_teacher, :is_administrative)
          .merge(university_id: current_university.id)
  end
end
