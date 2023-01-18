require "test_helper"

class ContactDetailsTest < ActiveSupport::TestCase

  test "country nil" do
    detail = ContactDetails::Country.new nil
    assert_nil detail.label
    assert_nil detail.url
  end

  test "country FR" do
    detail = ContactDetails::Country.new 'FR'
    assert_equal 'France', detail.label
    assert_equal 'FR', detail.url
  end

  test "email nil" do
    detail = ContactDetails::Email.new nil
    assert_nil detail.label
    assert_nil detail.url
  end

  test "email arnaud.levy@noesya.coop" do
    detail = ContactDetails::Email.new 'arnaud.levy@noesya.coop'
    assert_equal 'arnaud.levy@noesya.coop', detail.label
    assert_equal 'mailto:arnaud.levy@noesya.coop', detail.url
  end

  test "twitter nil" do
    detail = ContactDetails::Twitter.new nil
    assert_nil detail.label
    assert_nil detail.url
  end

  test "twitter handle" do
    detail = ContactDetails::Twitter.new 'arnaudlevy'
    assert_equal 'arnaudlevy', detail.label
    assert_equal 'https://twitter.com/arnaudlevy', detail.url
  end

  test "mastodon nil" do
    detail = ContactDetails::Mastodon.new nil
    assert_nil detail.label
    assert_nil detail.url
  end

  test "mastodon mastodon.social/@arnaudlevy" do
    detail = ContactDetails::Mastodon.new 'mastodon.social/@arnaudlevy'
    assert_equal 'mastodon.social/@arnaudlevy', detail.label
    assert_equal 'https://mastodon.social/@arnaudlevy', detail.url
  end

  test "mastodon https://mastodon.social/@arnaudlevy" do
    detail = ContactDetails::Mastodon.new 'https://mastodon.social/@arnaudlevy'
    assert_equal 'mastodon.social/@arnaudlevy', detail.label
    assert_equal 'https://mastodon.social/@arnaudlevy', detail.url
  end

  test "twitter twitter.com/arnaudlevy" do
    detail = ContactDetails::Twitter.new 'twitter.com/arnaudlevy'
    assert_equal 'arnaudlevy', detail.label
    assert_equal 'https://twitter.com/arnaudlevy', detail.url
  end

  test "twitter https://twitter.com/arnaudlevy" do
    detail = ContactDetails::Twitter.new 'https://twitter.com/arnaudlevy'
    assert_equal 'arnaudlevy', detail.label
    assert_equal 'https://twitter.com/arnaudlevy', detail.url
  end

  test "website nil" do
    detail = ContactDetails::Website.new nil
    assert_nil detail.label
    assert_nil detail.url
  end

  test "website www.noesya.coop" do
    detail = ContactDetails::Website.new 'www.noesya.coop'
    assert_equal 'www.noesya.coop', detail.label
    assert_equal 'https://www.noesya.coop', detail.url
  end

  test "website https://www.noesya.coop" do
    detail = ContactDetails::Website.new 'https://www.noesya.coop'
    assert_equal 'www.noesya.coop', detail.label
    assert_equal 'https://www.noesya.coop', detail.url
  end

end