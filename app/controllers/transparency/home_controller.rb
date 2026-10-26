class Transparency::HomeController < Transparency::ApplicationController
  def index
    @universities = University.contributing.ordered
    @contributions_total = University.sum(:contribution_amount)

    @costs = Server::Cost.ordered
    @costs_total = Server::Cost.sum(:annual_amount)

    @balance = @contributions_total - @costs_total
  end
end
