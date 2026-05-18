class Showcase::InstancesController < Showcase::ApplicationController
  def index
    @instances = University.with_websites_in_production
                           .with_attached_logo
                           .ordered
  end
end
