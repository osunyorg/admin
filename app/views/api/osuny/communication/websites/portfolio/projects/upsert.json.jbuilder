json.created do
  json.partial! "api/osuny/communication/websites/portfolio/projects/project", collection: @successfully_created_projects, as: :project
end
json.updated do
  json.partial! "api/osuny/communication/websites/portfolio/projects/project", collection: @successfully_updated_projects, as: :project
end
json.errors do
  json.array! @invalid_projects_with_index do |invalid_project_with_index|
    json.index invalid_project_with_index[:index]
    json.errors invalid_project_with_index[:project].errors
  end
end
