require "test_helper"

# rails test test/models/communication/file/localization/with_acl_test.rb
class Communication::File::Localization::WithAclTest < ActiveSupport::TestCase
  def test_blob_acl_is_public_when_published
    l10n = Communication::File::Localization.new
    l10n.define_singleton_method(:published?) { true }
    assert_equal Communication::File::Localization::WithAcl::ACL_PUBLIC, l10n.blob_acl
  end

  def test_blob_acl_is_private_when_not_published
    l10n = Communication::File::Localization.new
    l10n.define_singleton_method(:published?) { false }
    assert_equal Communication::File::Localization::WithAcl::ACL_PRIVATE, l10n.blob_acl
  end

  def test_no_synchronization_without_a_blob
    l10n = Communication::File::Localization.new
    refute l10n.send(:should_synchronize_blob_acl?)
  end

  def test_synchronization_when_publication_changes
    l10n = Communication::File::Localization.new(original_blob_id: SecureRandom.uuid)
    l10n.define_singleton_method(:saved_change_to_original_blob_id?) { false }
    l10n.define_singleton_method(:saved_change_to_published_at?) { false }
    l10n.define_singleton_method(:saved_change_to_published?) { true }
    assert l10n.send(:should_synchronize_blob_acl?)
  end

  def test_synchronization_when_blob_changes
    l10n = Communication::File::Localization.new(original_blob_id: SecureRandom.uuid)
    l10n.define_singleton_method(:saved_change_to_original_blob_id?) { true }
    l10n.define_singleton_method(:saved_change_to_published_at?) { false }
    l10n.define_singleton_method(:saved_change_to_published?) { false }
    assert l10n.send(:should_synchronize_blob_acl?)
  end
end
