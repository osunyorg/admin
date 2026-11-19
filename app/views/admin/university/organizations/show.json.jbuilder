json.name @l10n.name
json.initials @l10n.initials
json.summary @l10n.summary
json.published @l10n.published?
json.logo url_for(@l10n.logo) if @l10n.logo.attached?