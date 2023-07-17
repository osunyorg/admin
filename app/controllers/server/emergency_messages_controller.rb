class Server::EmergencyMessagesController < Server::ApplicationController
  load_and_authorize_resource

  def index
    @emergency_messages =  @emergency_messages.reorder(created_at: :desc)
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
    if @emergency_message.save
      redirect_to [:server, @emergency_message], notice: t('admin.successfully_created_html', model: @emergency_message.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @emergency_message.update(emergency_message_params)
      redirect_to [:server, @emergency_message], notice: t('admin.successfully_updated_html', model: @emergency_message.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end
  
  def deliver
    @emergency_message.deliver!
    redirect_to [:server, @emergency_message], notice: t('server_admin.emergency_messages.delivered')
  end

  def destroy
    @emergency_message.destroy
    redirect_to server_emergency_messages_url, notice: t('admin.successfully_destroyed_html', model: @emergency_message.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb EmergencyMessage.model_name.human(count: 2), server_emergency_messages_path
    if @emergency_message
      if @emergency_message.persisted?
        add_breadcrumb @emergency_message, [:server, @emergency_message]
      else
        add_breadcrumb t('create')
      end
    end
  end

  def emergency_message_params
    params.require(:emergency_message).permit(:name, :subject_fr, :subject_en, :content_fr, :content_en, :university_id, :role)
  end
end
