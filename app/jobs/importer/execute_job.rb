class Importer::ExecuteJob < ApplicationJob
  queue_as :elephant

  def perform(import)
    importer_class = "Importers::#{import.kind.camelize}".constantize
    importer_class.execute(import)
  end
end