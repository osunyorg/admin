module User::WithAvatar
  extend ActiveSupport::Concern

  included do
    has_one_attached_deletable :picture # Nota: user has a picture_url property for SSO mapping. If picture_url is set it will use the url to change the picture

    validates :picture, size: { less_than: 5.megabytes }

    before_save :update_picture, if: :will_save_change_to_picture_url?
    after_save :update_picture_url
  end

  private

  def update_picture
    if picture_url.blank?
      do_purge_picture
    else
      do_update_picture
    end
  end

  def update_picture_url
    if picture_url.present? && !picture.attached?
      self.update_column(:picture_url, nil)
    end
  end

  def do_purge_picture
    self.picture.purge if self.picture.attached?
  end

  def do_update_picture
    downloaded_image = open(picture_url)
    content_type = downloaded_image.content_type
    extension = content_type.split('/').last
    self.picture.attach(io: downloaded_image, filename: "avatar.#{extension}")
  end
end
