require "test_helper"

class SummernoteCleanerTest < ActiveSupport::TestCase
  test "add p around text if missing" do
    text = 'Les étudiants doivent s\'acquitter des droits universitaires annuels (170€ pour 2021/2022) ainsi que de la Contribution de la Vie Étudiante et de Campus (92€ pour 2021/2022). Ils doivent également justifier d\'une assurance responsabilité civile.<br>Plus d\'informations dans la rubrique → <a href="https://bordeauxmontaigne-iut.netlify.app/vie-etudiante/scolarite/frais-dinscription">Scolarité</a>'
    assert_equal '<p>Les étudiants doivent s\'acquitter des droits universitaires annuels (170€ pour 2021/2022) ainsi que de la Contribution de la Vie Étudiante et de Campus (92€ pour 2021/2022). Ils doivent également justifier d\'une assurance responsabilité civile.<br>Plus d\'informations dans la rubrique → <a href="https://bordeauxmontaigne-iut.netlify.app/vie-etudiante/scolarite/frais-dinscription">Scolarité</a></p>', SummernoteCleaner.clean(text)
  end

end
