require "test_helper"

# rails test test/services/variant_service_test.rb
class VariantServiceTest < ActiveSupport::TestCase
  self.file_fixture_path = File.expand_path("../fixtures/files", __dir__)

  include ActiveRecord::TestFixtures

  # L'image de test meure 1486 pixels de large et 836 pixels de haut

  EXPECTED_PARAMS_PER_FILENAME = [
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
    # Pas de taille, pas de crop.
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

  EXPECTED_TRANSFORMATIONS_PER_FILENAME = [
    ['dan-gold.jpeg', {}],
    ['dan-gold.webp', { format: 'webp' }],
    ['dan-gold_500x500.jpeg', { resize_to_limit: [500, 500] }],
    ['dan-gold_500x.jpeg', { resize_to_limit: [500, nil] }],
    ['dan-gold_x500.jpeg', { resize_to_limit: [nil, 500] }],
    ['dan-gold_crop_left.jpeg', {}],
    ['dan-gold@2x.jpeg', { resize_to_limit: [2972, 1672] }],
    ['dan-gold_500x500_crop_left.jpeg', { resize_to_fill: [500, 500, { gravity: 'West' }], crop: '500x500+0+0' }],
    # FIXME too big, useless -> { resize_to_limit: [836, 836] }
    ['dan-gold_500x500@2x.jpeg', { resize_to_limit: [1000, 1000] }],
    ['dan-gold_250x250@3x.jpeg', { resize_to_limit: [750, 750] }],
    # FIXME too big and no crop, useless -> { }
    ['dan-gold_crop_left@2x.jpeg', { resize_to_fill: [2972, 1672, {gravity: 'West'}], crop: '2972x1672+0+0' }],
    ['dan-gold_250x250_crop_left@2x.jpeg', { resize_to_fill: [500, 500, { gravity: 'West' }], crop: '500x500+0+0' }],
    ['dan-gold_200x300_crop_top.jpeg', { resize_to_fill: [200, 300, { gravity: 'North' }], crop: '200x300+0+0' }],
    ['dan-gold_300x200_crop_right@2x.jpeg', { resize_to_fill: [600, 400, { gravity: 'East' }], crop: '600x400+0+0' }],
    ['dan-gold_1000x500_crop_left.jpeg', { resize_to_fill: [1000, 500, { gravity: 'West' }], crop: '1000x500+0+0' }],
    # FIXME too big, useless -> { resize_to_fill: [1486, 495, {gravity: 'West'}], crop: '1486x495+0+0' }
    ['dan-gold_1500x500_crop_left.jpeg', { resize_to_fill: [1500, 500, {gravity: 'West'}], crop: '1500x500+0+0' }],
    # FIXME slightly too big -> resize_to_fill: [796, 836, {gravity: "West"}], crop: "796x836+0+0"
    ['dan-gold_800x840_crop_left.jpeg', resize_to_fill: [800, 840, {gravity: "West"}], crop: "800x840+0+0"],
    ['dan-gold', { }],
    ['dan-gold_500x500', { resize_to_limit: [500, 500] }],
  ]

  EXPECTED_KEYCDN_PARAMS_PER_FILENAME = [
    ['dan-gold.jpeg', { }],
    ['dan-gold.webp', { format: 'webp' }],
    ['dan-gold_500x500.jpeg', { width: 500, height: 500 }],
    ['dan-gold_500x.jpeg', { width: 500, enlarge: 0 }],
    ['dan-gold_x500.jpeg', { height: 500, enlarge: 0 }],
    ['dan-gold_crop_left.jpeg', { }],
    ['dan-gold@2x.jpeg', { width: 1486, height: 836 }],
    ['dan-gold_500x500_crop_left.jpeg', { width: 500, height: 500, position: 'left' }],
    # Si on ne peut pas créer un crop de la taille demandée (pas assez de définition), on reste homothétique, et on monte à la taille maximale possible
    ['dan-gold_500x500@2x.jpeg', { width: 836, height: 836 }],
    ['dan-gold_2000x2000.jpeg', { width: 836, height: 836 }],
    ['dan-gold_1000x2000.jpeg', { width: 418, height: 836 }],
    ['dan-gold_2000x1000.jpeg', { width: 1486, height: 743 }],
    # Là on peut (l'image fait 836), donc rien de spécial
    ['dan-gold_250x250@3x.jpeg', { width: 750, height: 750 }],
    # Pas de taille, pas de crop.
    ['dan-gold_crop_left@2x.jpeg', { width: 1486, height: 836, position: 'left' }],
    ['dan-gold_250x250_crop_left@2x.jpeg', { width: 500, height: 500, position: 'left'  }],
    ['dan-gold_200x300_crop_top.jpeg', { width: 200, height: 300, position: 'top' }],
    ['dan-gold_300x200_crop_right@2x.jpeg', { width: 600, height: 400, position: 'right' }],
    ['dan-gold_1000x500_crop_left.jpeg', { width: 1000, height: 500, position: 'left' }],
    ['dan-gold_1500x500_crop_left.jpeg', { width: 1486, height: 495, position: 'left' }],
    ['dan-gold_800x840_crop_left.jpeg', { width: 796, height: 836, position: 'left' }],
    ['dan-gold', {}],
    ['dan-gold_500x500', { width: 500, height: 500 }],
  ]

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

  test "Active Storage params matrix" do
    EXPECTED_PARAMS_PER_FILENAME.each do |filename, output|
      blob = create_file_blob(filename: "dan-gold.jpeg")
      variant_service = VariantService.manage(blob, { filename_with_transformations: filename })
      assert_equal output, variant_service.params
    end
  end

  test "transformations matrix" do
    EXPECTED_TRANSFORMATIONS_PER_FILENAME.each do |filename, output|
      blob = create_file_blob(filename: "dan-gold.jpeg")
      variant_service = VariantService.manage(blob, { filename_with_transformations: filename })
      assert_equal output, variant_service.transformations
    end
  end

  test "KeyCDN params matrix" do
    EXPECTED_KEYCDN_PARAMS_PER_FILENAME.each do |filename, output|
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
