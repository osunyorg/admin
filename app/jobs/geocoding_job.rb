class GeocodingJob < ApplicationJob
  queue_as :mice

  def perform(object)
    object.geocode
    object.save
  end
end