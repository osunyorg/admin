class AddDateToCommunicationWebsitePortfolioProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_website_portfolio_projects, :from_day, :date
    Communication::Website::Portfolio::Project.reset_column_information
    Communication::Website::Portfolio::Project.find_each do |project|
      from_day = Date.new(project.year)
      project.update_column :from_day, from_day
    end
  end
end
