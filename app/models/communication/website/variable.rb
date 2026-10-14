# == Schema Information
#
# Table name: communication_website_variables
#
#  id                       :uuid             not null, primary key
#  key                      :integer          not null, uniquely indexed => [communication_website_id]
#  value                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, uniquely indexed => [key]
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_key_682d89f654          (communication_website_id,key) UNIQUE
#  index_communication_website_variables_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_4456395cc9  (communication_website_id => communication_websites.id)
#  fk_rails_dd52f530c2  (university_id => universities.id)
#
class Communication::Website::Variable < ApplicationRecord
  self.filter_attributes += [:value]

  belongs_to :university
  belongs_to :communication_website, class_name: 'Communication::Website'

  enum :key, {
    SFTP_HOST: 100,
    SFTP_PORT: 101,
    SFTP_USER: 102,
    SFTP_PASSWORD: 103,
    SFTP_PATH: 104,
    DXFL_BUCKET: 200,
    RSYNC_HOST: 300,
    RSYNC_PORT: 301,
    RSYNC_USER: 302,
    RSYNC_PATH: 303,
    RSYNC_SSH_PRIVATE_KEY: 304,
    S3_BUCKET: 400,
    S3_ENDPOINT: 401,
    S3_REGION: 402,
    AWS_ACCESS_KEY_ID: 403,
    AWS_SECRET_ACCESS_KEY: 404
  }

  KEYS_BY_SYNC_METHOD = {
    'sftp' => [
      'SFTP_HOST',
      'SFTP_PORT',
      'SFTP_USER',
      'SFTP_PASSWORD',
      'SFTP_PATH'
    ],
    'dxfl' => [
      'DXFL_BUCKET',
      'AWS_ACCESS_KEY_ID',
      'AWS_SECRET_ACCESS_KEY'
    ],
    'rsync' => [
      'RSYNC_HOST',
      'RSYNC_PORT',
      'RSYNC_USER',
      'RSYNC_PATH',
      'RSYNC_SSH_PRIVATE_KEY'
    ],
    's3' => [
      'S3_BUCKET',
      'S3_ENDPOINT',
      'S3_REGION',
      'AWS_ACCESS_KEY_ID',
      'AWS_SECRET_ACCESS_KEY'
    ]
  }.freeze

  SECRET_KEYS = [
    'SFTP_PASSWORD',
    'RSYNC_SSH_PRIVATE_KEY',
    'AWS_SECRET_ACCESS_KEY'
  ].freeze

  MULTILINE_KEYS = [
    'RSYNC_SSH_PRIVATE_KEY'
  ].freeze

  validates :key, presence: true, uniqueness: { scope: :communication_website_id }

  # Un secret enregistré n'est jamais renvoyé au navigateur : un champ vide signifie "ne pas modifier"
  before_validation :keep_secret_value_if_blank
  before_validation :set_university
  # Les secrets sont chiffrés avec la clé publique de Kelmscott (libsodium sealed box), seul Kelmscott peut les déchiffrer
  validate :kelmscott_public_key_must_be_present, if: :secret_value_to_encrypt?
  before_save :encrypt_secret_value, if: :secret_value_to_encrypt?

  def to_s
    "#{key}"
  end

  def self.keys_for(sync_method)
    KEYS_BY_SYNC_METHOD.fetch(sync_method.to_s, [])
  end

  def secret?
    key.in?(SECRET_KEYS)
  end

  def multiline?
    key.in?(MULTILINE_KEYS)
  end

  protected

  def keep_secret_value_if_blank
    return unless persisted? && secret? && value.blank?
    restore_attributes [:value]
  end

  def set_university
    self.university_id ||= communication_website&.university_id
  end

  def secret_value_to_encrypt?
    secret? && will_save_change_to_value? && value.present?
  end

  def kelmscott_public_key_must_be_present
    errors.add(:value, :kelmscott_public_key_missing) if ENV['KELMSCOTT_PUBLIC_KEY'].blank?
  end

  def encrypt_secret_value
    self.value = Base64.strict_encode64(libsodium_box.encrypt(value))
  end

  def libsodium_box
    public_key = RbNaCl::PublicKey.new(Base64.strict_decode64(ENV['KELMSCOTT_PUBLIC_KEY']))
    RbNaCl::Boxes::Sealed.from_public_key(public_key)
  end
end
