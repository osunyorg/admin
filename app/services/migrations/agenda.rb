class Migrations::Agenda
  def self.migrate
    Communication::Website::Page.where(type: 'Communication::Website::Page::CommunicationAgendaArchive').find_each do |page|
      page.localizations.each do |l10n|
        l10n.unpublish!
      end
    end
  end
end