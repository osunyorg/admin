require "test_helper"

# rails test test/services/variant_service_test.rb
class VariantServiceTest < ActiveSupport::TestCase
  self.file_fixture_path = File.expand_path("../fixtures/files", __dir__)

  include ActiveRecord::TestFixtures

  setup do
    @was_tracking, ActiveStorage.track_variants = ActiveStorage.track_variants, false
  end

  teardown do
    ActiveStorage.track_variants = @was_tracking
  end

  # Class

  test "params for dan-gold.jpeg with ActiveStorage" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    variant_service = VariantService.manage(blob, { filename_with_transformations: 'dan-gold.jpeg' })
    assert_equal VariantService::ActiveStorage, variant_service.class
  end

  test "params for dan-gold.jpeg with KeyCDN" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    variant_service = VariantService.manage(blob, { filename_with_transformations: 'dan-gold.jpeg', keycdn: 'true' })
    assert_equal VariantService::KeyCdn, variant_service.class
  end

  # Format

  test "params for dan-gold.jpeg" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    expected_params = {}
    variant_service = VariantService.manage(blob, { filename_with_transformations: 'dan-gold.jpeg', })
    assert_equal 'jpeg', variant_service.format
  end

  test "params for dan-gold.jpeg same format" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    variant_service = VariantService.manage(blob, { filename_with_transformations: 'dan-gold.jpeg', format: 'jpeg' })
    assert_equal 'jpeg', variant_service.format
  end

  test "params for dan-gold.webp" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    variant_service = VariantService.manage(blob, { filename_with_transformations: 'dan-gold.jpeg', format: 'webp' })
    assert_equal 'webp', variant_service.format
  end

  # Params

  PARAMS = [
    [{ filename_with_transformations: 'dan-gold.jpeg' }, {}],
    [{ filename_with_transformations: 'dan-gold.jpeg' }, {}],
    [{ filename_with_transformations: 'dan-gold_500x500.jpeg' }, { size: [500, 500] }],
    [{ filename_with_transformations: 'dan-gold_500x.jpeg' }, { size: [500, nil] }],
    [{ filename_with_transformations: 'dan-gold_x500.jpeg' }, { size: [nil, 500] }],
    [{ filename_with_transformations: 'dan-gold_crop_left.jpeg' }, { gravity: 'West' }],
    [{ filename_with_transformations: 'dan-gold@2x.jpeg' }, { scale: 2 }],
    [{ filename_with_transformations: 'dan-gold_500x500_crop_left.jpeg' }, { size: [500, 500], gravity: 'West' }],
    [{ filename_with_transformations: 'dan-gold_500x500@2x.jpeg' }, { size: [500, 500], scale: 2 }],
    [{ filename_with_transformations: 'dan-gold_250x250@3x.jpeg' }, { size: [250, 250], scale: 3 }],
    [{ filename_with_transformations: 'dan-gold_crop_left@2x.jpeg' }, { gravity: 'West', scale: 2 }],
    [{ filename_with_transformations: 'dan-gold_250x250_crop_left@2x.jpeg' }, { size: [250, 250], gravity: 'West', scale: 2 }],
    [{ filename_with_transformations: 'dan-gold_200x300_crop_top.jpeg' }, { size: [200, 300], gravity: 'North' }],
    [{ filename_with_transformations: 'dan-gold_300x200_crop_right@2x.jpeg' }, { size: [300, 200], gravity: 'East', scale: 2 }],
    [{ filename_with_transformations: 'dan-gold_1000x500_crop_left.jpeg' }, { size: [1000, 500], gravity: 'West' }],
    [{ filename_with_transformations: 'dan-gold_1500x500_crop_left.jpeg' }, { size: [1500, 500], gravity: 'West' }],
    [{ filename_with_transformations: 'dan-gold_800x840_crop_left.jpeg' }, { size: [800, 840], gravity: 'West' }],
    [{ filename_with_transformations: 'dan-gold' }, {}],
    [{ filename_with_transformations: 'dan-gold_500x500' }, { size: [500, 500] }],
  ]

  test "params matrix" do
    PARAMS.each do |input, output|
      blob = create_file_blob(filename: "dan-gold.jpeg")
      variant_service = VariantService.manage(blob, input)
      assert_equal output, variant_service.params
    end
  end

  # Transformations

  TRANSFORMATIONS = [
    [{ filename_with_transformations: 'dan-gold.jpeg' }, {}],
    [{ filename_with_transformations: 'dan-gold.webp' }, { format: 'webp' }],
    [{ filename_with_transformations: 'dan-gold_500x500.jpeg' }, { resize_to_limit: [500, 500] }],
    [{ filename_with_transformations: 'dan-gold_500x.jpeg' }, { resize_to_limit: [500, nil] }],
    [{ filename_with_transformations: 'dan-gold_x500.jpeg' }, { resize_to_limit: [nil, 500] }],
    [{ filename_with_transformations: 'dan-gold_crop_left.jpeg' }, {}],
    [{ filename_with_transformations: 'dan-gold@2x.jpeg' }, { resize_to_limit: [2972, 1672] }],
    [{ filename_with_transformations: 'dan-gold_500x500_crop_left.jpeg' }, { resize_to_fill: [500, 500, { gravity: 'West' }], crop: '500x500+0+0' }],
    [{ filename_with_transformations: 'dan-gold_500x500@2x.jpeg' }, { resize_to_limit: [1000, 1000] }],
    [{ filename_with_transformations: 'dan-gold_250x250@3x.jpeg' }, { resize_to_limit: [750, 750] }],
    [{ filename_with_transformations: 'dan-gold_crop_left@2x.jpeg' }, { resize_to_limit: [2972, 1672] }],
    [{ filename_with_transformations: 'dan-gold_250x250_crop_left@2x.jpeg' }, { resize_to_fill: [500, 500, { gravity: 'West' }], crop: '500x500+0+0' }],
    [{ filename_with_transformations: 'dan-gold_200x300_crop_top.jpeg' }, { resize_to_fill: [200, 300, { gravity: 'North' }], crop: '200x300+0+0' }],
    [{ filename_with_transformations: 'dan-gold_300x200_crop_right@2x.jpeg' }, { resize_to_fill: [600, 400, { gravity: 'East' }], crop: '600x400+0+0' }],
    [{ filename_with_transformations: 'dan-gold_1000x500_crop_left.jpeg' }, { resize_to_fill: [1000, 500, { gravity: 'West' }], crop: '1000x500+0+0' }],
    [{ filename_with_transformations: 'dan-gold_1500x500_crop_left.jpeg' }, { resize_to_limit: [1500, 500] }],
    [{ filename_with_transformations: 'dan-gold_800x840_crop_left.jpeg' }, { resize_to_limit: [800, 840] }],
    [{ filename_with_transformations: 'dan-gold' }, { }],
    [{ filename_with_transformations: 'dan-gold_500x500' }, { resize_to_limit: [500, 500] }],
  ]

  test "transfomrations matrix" do
    TRANSFORMATIONS.each do |input, output|
      blob = create_file_blob(filename: "dan-gold.jpeg")
      variant_service = VariantService.manage(blob, input)
      assert_equal output, variant_service.transformations
    end
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
