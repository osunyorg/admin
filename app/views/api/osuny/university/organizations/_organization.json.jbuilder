json.extract! organization,
              :id, :migration_identifier, :kind, :active,
              :email, :phone, :address, :zipcode, :city, :country,
              :latitude, :longitude, :nic, :siren
json.localizations do
  organization.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/university/organizations/localization", l10n: l10n
    end
  end
end
json.extract! organization, :category_ids
json.extract! organization, :created_at, :updated_at
