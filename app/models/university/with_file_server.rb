module University::WithFileServer
  extend ActiveSupport::Concern

  included do
    has_one :file_server

    accepts_nested_attributes_for :file_server, reject_if: :all_blank
  end

  def file_server?
    file_server.present? && file_server.correct?
  end
end
