require "test_helper"

class VariantServiceTest < ActiveSupport::TestCase
  self.file_fixture_path = File.expand_path("../fixtures/files", __dir__)

  include ActiveRecord::TestFixtures

  setup do
    ActiveStorage::Current.host = "https://example.com"
    @was_tracking, ActiveStorage.track_variants = ActiveStorage.track_variants, false
  end

  teardown do
    ActiveStorage::Current.reset
    ActiveStorage.track_variants = @was_tracking
  end

  # = Examples =
  # dan-gold.jpeg
  # dan-gold.webp
  # dan-gold_500x500.jpeg
  # dan-gold_500x.jpeg
  # dan-gold_x500.jpeg
  # dan-gold_crop_left.jpeg
  # dan-gold@2x.jpeg
  # dan-gold_500x500_crop_left.jpeg
  # dan-gold_500x500@2x.jpeg
  # dan-gold_250x250@3x.jpeg
  # dan-gold_crop_left@2x.jpeg
  # dan-gold_250x250_crop_left@2x.jpeg
  # dan-gold_200x300_crop_top.jpeg
  # dan-gold_300x200_crop_right@2x.jpeg
  # dan-gold_1000x500_crop_left.jpeg

  # Params tests

  test "params for dan-gold.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = {}
    variant_service = VariantService.compute(blob, 'dan-gold', 'jpeg')
    assert_equal expected_params, variant_service.params
    assert_equal 'jpeg', variant_service.format
  end

  test "params for dan-gold.webp" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = {}
    variant_service = VariantService.compute(blob, 'dan-gold', 'webp')
    assert_equal expected_params, variant_service.params
    assert_equal 'webp', variant_service.format
  end

  test "params for dan-gold_500x500.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '500x500' }
    variant_service = VariantService.compute(blob, 'dan-gold_500x500', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_500x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '500x' }
    variant_service = VariantService.compute(blob, 'dan-gold_500x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_x500.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: 'x500' }
    variant_service = VariantService.compute(blob, 'dan-gold_x500', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { gravity: 'West' }
    variant_service = VariantService.compute(blob, 'dan-gold_crop_left', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { scale: 2 }
    variant_service = VariantService.compute(blob, 'dan-gold@2x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_500x500_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '500x500', gravity: 'West' }
    variant_service = VariantService.compute(blob, 'dan-gold_500x500_crop_left', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_500x500@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '500x500', scale: 2 }
    variant_service = VariantService.compute(blob, 'dan-gold_500x500@2x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_250x250@3x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '250x250', scale: 3 }
    variant_service = VariantService.compute(blob, 'dan-gold_250x250@3x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_crop_left@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { gravity: 'West', scale: 2 }
    variant_service = VariantService.compute(blob, 'dan-gold_crop_left@2x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_250x250_crop_left@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '250x250', gravity: 'West', scale: 2 }
    variant_service = VariantService.compute(blob, 'dan-gold_250x250_crop_left@2x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_200x300_crop_top.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '200x300', gravity: 'North' }
    variant_service = VariantService.compute(blob, 'dan-gold_200x300_crop_top', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_300x200_crop_right@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '300x200', gravity: 'East', scale: 2 }
    variant_service = VariantService.compute(blob, 'dan-gold_300x200_crop_right@2x', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_1000x500_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '1000x500', gravity: 'West' }
    variant_service = VariantService.compute(blob, 'dan-gold_1000x500_crop_left', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  # Transformations tests

  # test "transformations for dan-gold.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = {}
  #   variant_service = VariantService.compute(blob, 'dan-gold', 'jpeg')
  #   assert_equal expected_transformations, variant_service.transformations
  # end
  #
  # test "transformations for dan-gold.webp" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = { format: 'webp' }
  #   variant_service = VariantService.compute(blob, 'dan-gold', 'webp')
  #   assert_equal expected_transformations, variant_service.transformations
  # end
  #
  # test "transformations for dan-gold_500x500.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = { resize_to_limit: [500, 500] }
  #   variant_service = VariantService.compute(blob, 'dan-gold_500x500', 'jpeg')
  #   assert_equal expected_transformations, variant_service.transformations
  # end
  #
  # test "transformations for dan-gold_500x.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = { resize_to_limit: [500, nil] }
  #   variant_service = VariantService.compute(blob, 'dan-gold_500x', 'jpeg')
  #   assert_equal expected_transformations, variant_service.transformations
  # end
  #
  # test "transformations for dan-gold_x500.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = { resize_to_limit: [nil, 836] }
  #   variant_service = VariantService.compute(blob, 'dan-gold_x500', 'jpeg')
  #   assert_equal expected_transformations, variant_service.transformations
  # end
  #
  # test "transformations for dan-gold_500x500_crop_left.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = {
  #     resize_to_fill: [500, 836, { gravity: 'West' }],
  #     crop: '500x836+0+0'
  #   }
  #   variant_service = VariantService.compute(blob, 'dan-gold_500x500_crop_left', 'jpeg')
  #   assert_equal expected_transformations, variant_service.transformations
  # end
  #
  # test "transformations for dan-gold_500x500_crop_left@2x.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = {
  #     resize_to_fill: [2000, 836, { gravity: 'West' }],
  #     crop: '2000x2000+0+0'
  #   }
  #   variant_service = VariantService.compute(blob, 'dan-gold_500x500_crop_left@2x', 'jpeg')
  #   assert_equal expected_transformations, variant_service.transformations
  # end
  #
  # test "transformations for dan-gold_crop_left.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = {}
  #   variant_service = VariantService.compute(blob, 'dan-gold_crop_left', 'jpeg')
  #   assert_equal expected_transformations, variant_service.transformations
  # end
  #
  # test "transformations for dan-gold@2x.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = {}
  #   variant_service = VariantService.compute(blob, 'dan-gold@2x', 'jpeg')
  #   assert_equal expected_transformations, variant_service.transformations
  # end
  #
  # test "transformations for dan-gold_crop_left@2x.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   expected_transformations = {}
  #   variant_service = VariantService.compute(blob, 'dan-gold_crop_left@2x', 'jpeg')
  #   assert_equal expected_transformations, variant_service.transformations
  # end

  # Variants tests

  test "variant for dan-gold.webp" do
    expected_blob = create_file_blob(filename: "dan-gold.webp")

    blob = create_file_blob(filename: "dan-gold.jpeg")
    variant_service = VariantService.compute(blob, 'dan-gold', 'webp')
    variant = blob.variant(variant_service.transformations).processed
    image = read_image(variant)

    assert_equal "WEBP", image.type
    assert_equal 1486, image.width
    assert_equal 836, image.height
    assert_equal expected_blob.checksum, image_checksum(image)
  end

  # test "variant for dan-gold_500x500.jpeg" do
  #   blob = create_file_blob(filename: "dan-gold.jpeg")
  #   variant_service = VariantService.compute(blob, 'dan-gold_500x500', 'jpeg')
  #   variant = blob.variant(variant_service.transformations).processed
  #   image = read_image(variant)
  #   assert_equal 500, image.width
  #   assert_equal 563, image.height
  # end

  private

  def create_file_blob(key: nil, filename: "dan-gold.jpeg", content_type: "image/jpeg", metadata: nil, service_name: nil, record: nil)
    ActiveStorage::Blob.create_and_upload! io: file_fixture(filename).open, filename: filename, content_type: content_type, metadata: metadata, service_name: service_name, record: record
  end

  def read_image(blob_or_variant)
    MiniMagick::Image.open blob_or_variant.service.send(:path_for, blob_or_variant.key)
  end

  def image_checksum(image)
    OpenSSL::Digest::MD5.base64digest(image.to_blob)
  end

  def extract_metadata_from(blob)
    blob.tap(&:analyze).metadata
  end
end
