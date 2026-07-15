class Communication::Website::DirectObject::ConnectDependenciesJob < ApplicationJob
  queue_as :mice

  def perform(direct_object)
    return if direct_object.paranoid? && direct_object.deleted?

    direct_object.connect_dependencies_safely
  end
end
