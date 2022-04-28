module Importable
  extend ActiveSupport::Concern

  included do
    belongs_to :user

    has_one_attached :file

    after_commit :parse_async
  end

  def lines
    csv.count
  rescue
    'NA'
  end

  def to_s
    "#{user}, #{I18n.l created_at}"
  end

  protected

  def parse_async
    parse
  end
  handle_asynchronously :parse_async, queue: 'default'

  def parse
    raise NotImplementedError
  end

  def csv
    @csv ||= CSV.parse file.blob.download, headers: true
  end
end
