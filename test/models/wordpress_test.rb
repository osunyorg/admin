require "test_helper"

class WordpressTest < ActiveSupport::TestCase
  test "convert apostroph" do
    assert_equal  'Ouverture du CRM pendant les vacances d’Avril',
                  Wordpress.clean_html('Ouverture du CRM pendant les vacances d&#8217;Avril')
  end

  test "convert 3 dots" do
    assert_equal  'Le CRM fait le tri dans ses collections … et vous propose une vente de livres',
                  Wordpress.clean_html('Le CRM fait le tri dans ses collections &#8230; et vous propose une vente de livres')
  end

  test "convert double quotation marks" do
    assert_equal  'Conférence Joëlle Zask : “Ecologie de la participation”',
                  Wordpress.clean_html('Conférence Joëlle Zask : &#8220;Ecologie de la participation&#8221;')
  end

  test "convert h1" do
    assert_equal  '<h2>B.U.T. Métiers du multimédia et de l’internet</h2>',
                  Wordpress.clean_html('<h1>B.U.T. Métiers du multimédia et de l&#8217;internet</h1>')
  end

  test "convert h2 without h1" do
    assert_equal  '<h2>B.U.T. Métiers du multimédia et de l’internet</h2>',
                  Wordpress.clean_html('<h2>B.U.T. Métiers du multimédia et de l&#8217;internet</h2>')
  end

  test "convert h2 with h1" do
    assert_equal  '<h2>Bachelor Universitaire de Technologie</h2><h3>B.U.T. Métiers du multimédia et de l’internet</h3>',
                  Wordpress.clean_html('<h1>Bachelor Universitaire de Technologie</h1><h2>B.U.T. Métiers du multimédia et de l&#8217;internet</h2>')
  end

  test "convert " do
    assert_equal  'TRAVAILLER DEMAIN, Débat – le 10 mai à 18h30',
                  Wordpress.clean_html('TRAVAILLER DEMAIN, Débat &#8211; le 10 mai à 18h30')
  end

  test "remove classes" do
    assert_equal  '<h2>→ Qu’est-ce que le B.U.T.&nbsp;?</h2>',
                  Wordpress.clean_html('<h2 class="titre-diplome">→ Qu’est-ce que le B.U.T.&nbsp;?</h2>')
  end

  test "remove line_separators (LSEP)" do
    # Invisible char before A, and html code
    assert_equal  "Au ",
                  Wordpress.clean_html(" Au &#8232;")
  end

  test "remove divs" do
    # Quid des images ? Comment gérer le transfert vers scaleway + active storage dans le code ?
    assert_equal  '<figure><a href="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1.png"><img src="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1-240x300.png" alt="Le BUT, qu\'est-ce que c\'est ?" width="173" height="216" srcset="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1-240x300.png 240w, https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1.png 730w"></a></figure>',
                  Wordpress.clean_html('<div class="wp-block-group"><div class="wp-block-group__inner-container"><div class="wp-block-columns"><div class="wp-block-column"><div class="wp-block-image"><figure class="alignright size-medium is-resized"><a href="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1.png" rel="lightbox[14475]"><img src="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1-240x300.png" alt="Le BUT, qu\'est-ce que c\'est ?" class="wp-image-14821" width="173" height="216" srcset="https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1-240x300.png 240w, https://www.iut.u-bordeaux-montaigne.fr/wp-content/uploads/2021/01/visuel_1.png 730w"></a></figure></div></div>')


  end

  test "convert &nbsp; in titles" do
    assert_equal  ' ',
                  Wordpress.clean_string '&nbsp;'
  end

  test "authorize iframes" do

  end
end
