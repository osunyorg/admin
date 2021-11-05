require "test_helper"

class VariantServiceTest < ActiveSupport::TestCase
  self.file_fixture_path = File.expand_path("../fixtures/files", __dir__)

  include ActiveRecord::TestFixtures

  setup do
    ActiveStorage::Current.host = "https://example.com"
  end

  teardown do
    ActiveStorage::Current.reset
    FileUtils.rm_rf("#{Rails.root}/tmp/storage")
  end

  test "params for dan-gold.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: nil, gravity: nil, scale: nil }
    variant_service = VariantService.compute(blob, 'dan-gold', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_1000x1000.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '1000x1000', gravity: nil, scale: nil }
    variant_service = VariantService.compute(blob, 'dan-gold_1000x1000', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_1000x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '1000x', gravity: nil, scale: nil }
    variant_service = VariantService.compute(blob, 'dan-gold_1000x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_x1000.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: 'x1000', gravity: nil, scale: nil }
    variant_service = VariantService.compute(blob, 'dan-gold_x1000', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_1000x1000_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '1000x1000', gravity: 'West', scale: nil }
    variant_service = VariantService.compute(blob, 'dan-gold_1000x1000_crop_left', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_1000x1000_crop_left@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '1000x1000', gravity: 'West', scale: 2 }
    variant_service = VariantService.compute(blob, 'dan-gold_1000x1000_crop_left@2x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: nil, gravity: 'West', scale: nil }
    variant_service = VariantService.compute(blob, 'dan-gold_crop_left', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: nil, gravity: nil, scale: 2 }
    variant_service = VariantService.compute(blob, 'dan-gold@2x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_crop_left@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: nil, gravity: 'West', scale: 2 }
    variant_service = VariantService.compute(blob, 'dan-gold_crop_left@2x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  private

  def create_file_blob(key: nil, filename: "dan-gold.jpeg", content_type: "image/jpeg", metadata: nil, service_name: nil, record: nil)
    ActiveStorage::Blob.create_and_upload! io: file_fixture(filename).open, filename: filename, content_type: content_type, metadata: metadata, service_name: service_name, record: record
  end
end
