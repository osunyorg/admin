require "test_helper"

class VariantServiceTest < ActiveSupport::TestCase
  self.file_fixture_path = File.expand_path("../fixtures/files", __dir__)

  include ActiveRecord::TestFixtures

  setup do
    @was_tracking, ActiveStorage.track_variants = ActiveStorage.track_variants, false
  end

  teardown do
    ActiveStorage.track_variants = @was_tracking
  end

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

  test "params for dan-gold_1500x500_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '1500x500', gravity: 'West' }
    variant_service = VariantService.compute(blob, 'dan-gold_1500x500_crop_left', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold_800x840_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '800x840', gravity: 'West' }
    variant_service = VariantService.compute(blob, 'dan-gold_800x840_crop_left', 'jpeg')
    assert_equal expected_params, variant_service.params
  end

  test "params for dan-gold" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = {}
    variant_service = VariantService.compute(blob, 'dan-gold', nil)
    assert_equal expected_params, variant_service.params
    assert_nil variant_service.format
  end

  test "params for dan-gold_500x500" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = { size: '500x500' }
    variant_service = VariantService.compute(blob, 'dan-gold_500x500', nil)
    assert_equal expected_params, variant_service.params
  end

  # Transformations tests

  test "transformations for dan-gold.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {}
    variant_service = VariantService.compute(blob, 'dan-gold', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold.webp" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = { format: 'webp' }
    variant_service = VariantService.compute(blob, 'dan-gold', 'webp')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_500x500.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = { resize_to_limit: [500, 500] }
    variant_service = VariantService.compute(blob, 'dan-gold_500x500', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_500x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = { resize_to_limit: [500, nil] }
    variant_service = VariantService.compute(blob, 'dan-gold_500x', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_x500.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = { resize_to_limit: [nil, 500] }
    variant_service = VariantService.compute(blob, 'dan-gold_x500', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {}
    variant_service = VariantService.compute(blob, 'dan-gold_crop_left', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {}
    variant_service = VariantService.compute(blob, 'dan-gold@2x', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_500x500_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {
      resize_to_fill: [500, 500, { gravity: 'West' }],
      crop: '500x500+0+0'
    }
    variant_service = VariantService.compute(blob, 'dan-gold_500x500_crop_left', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_500x500@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = { resize_to_limit: [1000, 1000] }
    variant_service = VariantService.compute(blob, 'dan-gold_500x500@2x', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_250x250@3x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = { resize_to_limit: [750, 750] }
    variant_service = VariantService.compute(blob, 'dan-gold_250x250@3x', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_crop_left@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {}
    variant_service = VariantService.compute(blob, 'dan-gold_crop_left@2x', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_250x250_crop_left@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {
      resize_to_fill: [500, 500, { gravity: 'West' }],
      crop: '500x500+0+0'
    }
    variant_service = VariantService.compute(blob, 'dan-gold_250x250_crop_left@2x', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_200x300_crop_top.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {
      resize_to_fill: [200, 300, { gravity: 'North' }],
      crop: '200x300+0+0'
    }
    variant_service = VariantService.compute(blob, 'dan-gold_200x300_crop_top', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_300x200_crop_right@2x.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {
      resize_to_fill: [600, 400, { gravity: 'East' }],
      crop: '600x400+0+0'
    }
    variant_service = VariantService.compute(blob, 'dan-gold_300x200_crop_right@2x', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_1000x500_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {
      resize_to_fill: [1000, 500, { gravity: 'West' }],
      crop: '1000x500+0+0'
    }
    variant_service = VariantService.compute(blob, 'dan-gold_1000x500_crop_left', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_1500x500_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = { resize_to_limit: [1500, 500] }
    variant_service = VariantService.compute(blob, 'dan-gold_1500x500_crop_left', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_800x840_crop_left.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = { resize_to_limit: [800, 840] }
    variant_service = VariantService.compute(blob, 'dan-gold_800x840_crop_left', 'jpeg')
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = {}
    variant_service = VariantService.compute(blob, 'dan-gold', nil)
    assert_equal expected_transformations, variant_service.transformations
  end

  test "transformations for dan-gold_500x500" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_transformations = { resize_to_limit: [500, 500] }
    variant_service = VariantService.compute(blob, 'dan-gold_500x500', nil)
    assert_equal expected_transformations, variant_service.transformations
  end

  private

  def create_file_blob(key: nil, filename: "dan-gold.jpeg", content_type: "image/jpeg", metadata: nil, service_name: nil, record: nil)
    blob = ActiveStorage::Blob.create_and_upload!   io: file_fixture(filename).open,
                                                    filename: filename,
                                                    content_type: content_type,
                                                    metadata: metadata,
                                                    service_name: service_name,
                                                    record: record
    blob.update_column :university_id, universities(:default_university).id
    blob
  end
end
