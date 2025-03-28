module Brevo
  class ContactService

    def self.sync(user)
      new(user).sync
    end

    def self.destroy(contact_id, university_id)
      api_instance = Brevo::ContactsApi.new
      other_user = User.where(brevo_contact_id: contact_id).first

      # If another User uses this contact_id (as users of multiple instances use the same contact in Brevo)
      # we just ensure that the current university_id for this user is not the deleted one
      if other_user.present?
        current_university_id_for_contact = api_instance.get_contact_info(contact_id).attributes[:UNIVERSITY_ID]
        self.sync(other_user) if current_university_id_for_contact == university_id
      else
        begin
          api_instance.delete_contact(contact_id)
        rescue Brevo::ApiError => e
          puts "Exception when calling ContactsApi->delete_contact: #{e}"
        end
      end
    end

    def initialize(user)
      @api_instance = Brevo::ContactsApi.new
      @user = user
    end

    def sync
      if existing_contact.present?
        # Handle the case when user was in Brevo but not in the app (or the user was destroyed and recreated in Sendinblue, so that the contact_id stored is now invalid)
        @user.update(brevo_contact_id: existing_contact.id) if @user.brevo_contact_id != existing_contact.id
        update_contact
      else
        create_contact
      end
    end

    private

    def existing_contact
      @existing_contact ||= begin
        contact_with_id = search_contact(@user.brevo_contact_id)
        contact_with_email = search_contact(@user.email)        
        contact_with_id || contact_with_email
      end
    end

    def search_contact(identifier)
      return nil if identifier.blank?
      begin
        @api_instance.get_contact_info(identifier)
      rescue Brevo::ApiError => e
        raise unless e.code == 404
        nil
      end
    end

    def create_contact
      create_contact = Brevo::CreateContact.new(
        email: @user.email,
        attributes: contact_attributes,
        emailBlacklisted: !@user.optin_newsletter?
      )
      result = @api_instance.create_contact(create_contact)
      @user.update(brevo_contact_id: result.id)
    end

    def update_contact
      update_contact = Brevo::UpdateContact.new(
        email: @user.email,
        attributes: contact_attributes,
        emailBlacklisted: !@user.optin_newsletter?
      )
      @api_instance.update_contact(@user.brevo_contact_id, update_contact)
    end

    def contact_attributes
      @contact_attributes ||= begin
        attributes = {
          'EMAIL' => @user.email,
          'LASTNAME' => @user.last_name,
          'FIRSTNAME' => @user.first_name,
          'UNIVERSITY_ID' => @user.university_id.to_s
        }
        attributes
      end
    end

  end
end