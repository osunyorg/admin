require "test_helper"

# rails test test/models/communication/file/localization_test.rb
class Communication::File::LocalizationTest < ActiveSupport::TestCase
  def test_acl
    Communication::File::Localization.any_instance.stubs(:s3_service?).returns(true)
    Communication::File::Localization.any_instance.stubs(:sync_blob_acl).returns(true)

    public_acl = Communication::File::Localization::ACL_PUBLIC
    private_acl = Communication::File::Localization::ACL_PRIVATE

    file_l10n = communication_file_localizations(:example_pdf_fr)
    file = file_l10n.about

    assert_equal(public_acl, file_l10n.send(:s3_acl))

    file_l10n.update(published: false)
    assert_equal(private_acl, file_l10n.send(:s3_acl))

    file_l10n.update(published: true)
    assert_equal(public_acl, file_l10n.send(:s3_acl))

    file.destroy
    file_l10n.reload
    assert(file_l10n.deleted?)
    assert_equal(private_acl, file_l10n.send(:s3_acl))

    file.restore(recursive: true)
    file_l10n.reload
    refute(file_l10n.deleted?)
    assert_equal(public_acl, file_l10n.send(:s3_acl))

  end
end
