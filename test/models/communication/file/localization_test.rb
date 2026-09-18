require "test_helper"

# rails test test/models/communication/file/localization_test.rb
class Communication::File::LocalizationTest < ActiveSupport::TestCase
  def test_acl
    Communication::File::Localization.any_instance.stubs(:s3_service?).returns(true)
    Communication::File::Localization.any_instance.stubs(:sync_blob_acl).returns(true)

    public_acl = Communication::File::Localization::ACL_PUBLIC
    private_acl = Communication::File::Localization::ACL_PRIVATE

    file = communication_files(:example_pdf)
    file_l10n = file.localizations.first

    assert_equal(public_acl, file_l10n.send(:s3_acl))
    Communication::File::Localization.any_instance.expects(:sync_blob_acl).times(4)

    file_l10n.update(published: false)
    assert_equal(private_acl, file_l10n.send(:s3_acl))

    file_l10n.update(published: true)
    assert_equal(public_acl, file_l10n.send(:s3_acl))

    file.destroy
    assert(file_l10n.reload.deleted?)
    assert_equal(private_acl, file_l10n.send(:s3_acl))

    file.restore(recursive: true)
    refute(file_l10n.reload.deleted?)
    assert_equal(public_acl, file_l10n.send(:s3_acl))

  end
end
