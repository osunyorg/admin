require "test_helper"

class WordpressTest < ActiveSupport::TestCase
  test "convert apostroph" do
    assert_equal  Wordpress.clean('Ouverture du CRM pendant les vacances d&#8217;Avril'),
                  'Ouverture du CRM pendant les vacances d’Avril'
  end

  test "convert 3 dots" do
    assert_equal  Wordpress.clean('Le CRM fait le tri dans ses collections &#8230; et vous propose une vente de livres'),
                  'Le CRM fait le tri dans ses collections … et vous propose une vente de livres'
  end

  test "convert double quotation marks" do
    assert_equal  Wordpress.clean('Conférence Joëlle Zask : &#8220;Ecologie de la participation&#8221;'),
                  'Conférence Joëlle Zask : “Ecologie de la participation”'
  end

  test "convert h1" do
    assert_equal  Wordpress.clean('<h1>B.U.T. Métiers du multimédia et de l&#8217;internet</h1>'),
                  '<h2>B.U.T. Métiers du multimédia et de l’internet</h2>'
  end

  test "convert h2 without h1" do
    assert_equal  Wordpress.clean('<h2>B.U.T. Métiers du multimédia et de l&#8217;internet</h2>'),
                  '<h2>B.U.T. Métiers du multimédia et de l’internet</h2>'
  end

  test "convert h2 with h1" do
    assert_equal  Wordpress.clean('<h1>Bachelor Universitaire de Technologie</h1><h2>B.U.T. Métiers du multimédia et de l&#8217;internet</h2>'),
                  '<h2>Bachelor Universitaire de Technologie</h2><h3>B.U.T. Métiers du multimédia et de l’internet</h3>'
  end

  test "convert " do
    assert_equal  Wordpress.clean('TRAVAILLER DEMAIN, Débat &#8211; le 10 mai à 18h30'),
                  'TRAVAILLER DEMAIN, Débat – le 10 mai à 18h30'
  end
end
