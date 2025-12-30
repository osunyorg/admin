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
    variant_service = VariantService.manage(blob, { filename_with_transformations: 'dan-gold.webp' })
    assert_equal 'webp', variant_service.format
  end

  test "params for dan-gold.jpeg with format webp" do
    blob = create_file_blob(filename: "dan-gold.jpeg")
    variant_service = VariantService.manage(blob, { filename_with_transformations: 'dan-gold.jpeg', format: 'webp' })
    assert_equal 'webp', variant_service.format
  end

  # Active Storage tests

  ACTIVE_STORAGE_PARAMS = [
    ['dan-gold.jpeg', {}],
    ['dan-gold.webp', { format: 'webp' }],
    ['dan-gold_500x500.jpeg', { size: [500, 500] }],
    ['dan-gold_500x.jpeg', { size: [500, nil] }],
    ['dan-gold_x500.jpeg', { size: [nil, 500] }],
    ['dan-gold_crop_left.jpeg', { gravity: 'West' }],
    ['dan-gold@2x.jpeg', { scale: 2 }],
    ['dan-gold_500x500_crop_left.jpeg', { size: [500, 500], gravity: 'West' }],
    ['dan-gold_500x500@2x.jpeg', { size: [500, 500], scale: 2 }],
    ['dan-gold_250x250@3x.jpeg', { size: [250, 250], scale: 3 }],
    ['dan-gold_crop_left@2x.jpeg', { gravity: 'West', scale: 2 }],
    ['dan-gold_250x250_crop_left@2x.jpeg', { size: [250, 250], gravity: 'West', scale: 2 }],
    ['dan-gold_200x300_crop_top.jpeg', { size: [200, 300], gravity: 'North' }],
    ['dan-gold_300x200_crop_right@2x.jpeg', { size: [300, 200], gravity: 'East', scale: 2 }],
    ['dan-gold_1000x500_crop_left.jpeg', { size: [1000, 500], gravity: 'West' }],
    ['dan-gold_1500x500_crop_left.jpeg', { size: [1500, 500], gravity: 'West' }],
    ['dan-gold_800x840_crop_left.jpeg', { size: [800, 840], gravity: 'West' }],
    ['dan-gold', {}],
    ['dan-gold_500x500', { size: [500, 500] }],
  ]

  test "Active Storage params matrix" do
    ACTIVE_STORAGE_PARAMS.each do |filename, output|
      blob = create_file_blob(filename: "dan-gold.jpeg")
      variant_service = VariantService.manage(blob, { filename_with_transformations: filename })
      assert_equal output, variant_service.params
    end
  end

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

  test "transformations matrix" do
    TRANSFORMATIONS.each do |input, output|
      blob = create_file_blob(filename: "dan-gold.jpeg")
      variant_service = VariantService.manage(blob, input)
      assert_equal output, variant_service.transformations
    end
  end

  # KeyCDN tests

  KEYCDN_PARAMS = [
    ['dan-gold.jpeg', {}],
    ['dan-gold.webp', { format: 'webp' }],
    ['dan-gold_500x500.jpeg', { width: 500, height: 500 }],
    ['dan-gold_500x.jpeg', { width: 500, enlarge: 0 }],
    ['dan-gold_x500.jpeg', { height: 500, enlarge: 0 }],
    ['dan-gold_crop_left.jpeg', { }],
    ['dan-gold@2x.jpeg', { width: 2972, enlarge: 0 }],
    ['dan-gold_500x500_crop_left.jpeg', { width: 500, height: 500, position: 'left' }],
    # FIXME je crois que si on demande une image de 500 par 500 en retina, on ne s'attend absolument pas à recevoir une image pas carrée sous prétexte que ce n'est pas assez grand
    ['dan-gold_500x500@2x.jpeg', { width: 1000, enlarge: 0 }],
    # FIXME idem
    ['dan-gold_250x250@3x.jpeg', { width: 750, height: 750 }],
    # FIXME Je ne sais pas ce que ce test veut dire (sans taille, pourquoi cropper ?)
    ['dan-gold_crop_left@2x.jpeg', { width: 2972, enlarge: 0 }],
    ['dan-gold_250x250_crop_left@2x.jpeg', { width: 500, height: 500, position: 'left'  }],
    ['dan-gold_200x300_crop_top.jpeg', { width: 200, height: 300, position: 'top' }],
    ['dan-gold_300x200_crop_right@2x.jpeg', { width: 600, height: 400, position: 'right' }],
    ['dan-gold_1000x500_crop_left.jpeg', { width: 1000, height: 500, position: 'left' }],
    ['dan-gold_1500x500_crop_left.jpeg', { width: 1500, enlarge: 0 }],
    ['dan-gold_800x840_crop_left.jpeg', { width: 800, enlarge: 0 }],
    ['dan-gold', {}],
    ['dan-gold_500x500', { width: 500, height: 500 }],
  ]

  test "KeyCDN params matrix" do
    KEYCDN_PARAMS.each do |filename, output|
      blob = create_file_blob(filename: "dan-gold.jpeg")
      variant_service = VariantService.manage(blob, { filename_with_transformations: filename, keycdn: 'true' })
      assert_equal output, variant_service.params
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
