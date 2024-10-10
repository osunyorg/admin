require "test_helper"

class ContactDetailsTest < ActiveSupport::TestCase

  KINDS = [
    :country,
    :email,
    :facebook,
    :github,
    :instagram,
    :linkedin,
    :mastodon,
    :peertube,
    :phone,
    :tiktok,
    :twitter,
    :vimeo,
    :website,
    :youtube
  ]

  test "nil is nil" do
    KINDS.each do |kind|
      detail = service_for(kind).new nil
      assert_nil detail.label
      assert_nil detail.value
    end
  end

  test "'' is nil" do
    KINDS.each do |kind|
      detail = service_for(kind).new ''
      assert_nil detail.label
      assert_nil detail.value
    end
  end

  test "country" do
    batch_test :country, 'France', 'FR', [
        'FR',
        'France',
        'FRANCE'
      ]
  end

  test "email" do
    batch_test :email, 'arnaud.levy@noesya.coop', 'mailto:arnaud.levy@noesya.coop', [
        'arnaud.levy@noesya.coop'
      ]
  end

  test 'facebook' do
    batch_test :facebook, 'noesya.coop', 'https://www.facebook.com/noesya.coop', [
        'noesya.coop',
        '@noesya.coop',
        'https://www.facebook.com/noesya.coop',
      ]
  end

  test 'github' do
    batch_test :github, 'noesya', 'https://github.com/noesya', [
        'noesya',
        'github.com/noesya',
        'https://github.com/noesya',
        'https://www.github.com/noesya',
      ]
  end

  test 'instagram' do
    batch_test :instagram, 'noesya_coop', 'https://instagram.com/noesya_coop', [
        'noesya_coop',
        '@noesya_coop',
        'https://instagram.com/noesya_coop',
      ]
  end

  test 'linkedin person' do
    batch_test :linkedin, 'arnaudlevy', 'https://www.linkedin.com/in/arnaudlevy/', [
        'https://www.linkedin.com/in/arnaudlevy/',
      ]
  end

  test 'linkedin company' do
    batch_test :linkedin, 'noesyacoop', 'https://www.linkedin.com/company/noesyacoop/', [
        'https://www.linkedin.com/company/noesyacoop/',
      ]
  end

  test "mastodon" do
    batch_test :mastodon, 'mastodon.social/@arnaudlevy', 'https://mastodon.social/@arnaudlevy', [
        'mastodon.social/@arnaudlevy',
        'https://mastodon.social/@arnaudlevy'
      ]
  end

  test "peertube" do
    batch_test :peertube, 'peertube.designersethiques.org', 'https://peertube.designersethiques.org', [
        'peertube.designersethiques.org',
        'https://peertube.designersethiques.org'
      ]
  end

  test "phone" do
    batch_test :phone, '+33 5 05 05 05 05', 'tel:+33505050505', [
        '+33 5 05 05 05 05',
        '+33.5.05.05.05.05',
      ]
  end

  test 'tiktok' do
    batch_test :tiktok, 'aliemeriaud', 'https://www.tiktok.com/@aliemeriaud', [
        'aliemeriaud',
        '@aliemeriaud',
        'https://www.tiktok.com/@aliemeriaud',
      ]
  end

  test "twitter or x" do
    batch_test :twitter, 'arnaudlevy', 'https://x.com/arnaudlevy', [
        'arnaudlevy',
        '@arnaudlevy',
        'twitter.com/arnaudlevy',
        'www.twitter.com/arnaudlevy',
        'http://twitter.com/arnaudlevy',
        'http://www.twitter.com/arnaudlevy',
        'https://twitter.com/arnaudlevy',
        'https://www.twitter.com/arnaudlevy',
        'x.com/arnaudlevy',
        'www.x.com/arnaudlevy',
        'http://x.com/arnaudlevy',
        'http://www.x.com/arnaudlevy',
        'https://x.com/arnaudlevy',
        'https://www.x.com/arnaudlevy'
      ]
  end

  test 'vimeo' do
    batch_test :vimeo, 'noesya', 'https://vimeo.com/noesya', [
        'noesya',
        '@noesya',
        'https://vimeo.com/noesya',
      ]
  end

  test 'website' do
    batch_test :website, 'www.noesya.coop', 'https://www.noesya.coop', [
        'www.noesya.coop',
        'https://www.noesya.coop'
      ]
  end

  test 'youtube' do
    batch_test :youtube, 'MMIBordeaux', 'https://www.youtube.com/@MMIBordeaux', [
        'MMIBordeaux',
        '@MMIBordeaux',
        'https://www.youtube.com/@MMIBordeaux',
      ]
  end

  protected

  def batch_test(kind, label, value, options)
    options.each do |option|
      detail = service_for(kind).new option
      assert_equal label, detail.label
      assert_equal value, detail.value
    end
  end

  def service_for(kind)
    "ContactDetails::#{kind.to_s.titleize}".constantize
  end
end