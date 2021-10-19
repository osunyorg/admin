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

  test "remove classes" do
    assert_equal  Wordpress.clean('<h2 class="titre-diplome">→ Qu’est-ce que le B.U.T.&nbsp;?</h2>'),
                  '<h2>→ Qu’est-ce que le B.U.T.&nbsp;?</h2>'
  end

  test "remove divs" do
    # Quid des images ? Comment gérer le transfert vers scaleway + active storage dans le code ?
    assert_equal  Wordpress.clean('<div class="wp-block-group"><div class="wp-block-group__inner-container"><div class="wp-block-columns"><div class="wp-block-column"><div class="wp-block-image"><figure class="alignright size-medium is-resized"><a href="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1.png" rel="lightbox[14475]"><img src="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1-240x300.png" alt="Le BUT, qu\'est-ce que c\'est ?" class="wp-image-14821" width="173" height="216" srcset="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1-240x300.png 240w, https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1.png 730w"></a></figure></div></div>'),
                  '<figure><a href="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1.png"><img src="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1-240x300.png" alt="Le BUT, qu\'est-ce que c\'est ?" width="173" height="216" srcset="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1-240x300.png 240w, https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1.png 730w"></a></figure>'

  end

  test "authorize iframes" do

  end
end
