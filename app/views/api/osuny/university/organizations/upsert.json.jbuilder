json.created do
  json.partial! "api/osuny/university/organizations/organization", collection: @successfully_created_organizations, as: :organization
end
json.updated do
  json.partial! "api/osuny/university/organizations/organization", collection: @successfully_updated_organizations, as: :organization
end
json.errors do
  json.array! @invalid_organizations_with_index do |invalid_organization_with_index|
    json.index invalid_organization_with_index[:index]
    json.errors invalid_organization_with_index[:organization].errors
  end
end