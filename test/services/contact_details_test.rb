require "test_helper"

class ContactDetailsTest < ActiveSupport::TestCase

  test "country nil" do
    detail = ContactDetails::Country.new nil
    assert_equal detail.label, ''
    assert_equal detail.url, ''
  end

  test "country FR" do
    detail = ContactDetails::Country.new 'FR'
    assert_equal detail.label, 'France'
    assert_equal detail.url, 'FR'
  end

  test "email nil" do
    detail = ContactDetails::Email.new nil
    assert_equal detail.label, ''
    assert_equal detail.url, ''
  end

  test "email arnaud.levy@noesya.coop" do
    detail = ContactDetails::Email.new 'arnaud.levy@noesya.coop'
    assert_equal detail.label, 'arnaud.levy@noesya.coop'
    assert_equal detail.url, 'mailto:arnaud.levy@noesya.coop'
  end

  test "twitter nil" do
    detail = ContactDetails::Twitter.new nil
    assert_equal detail.label, ''
    assert_equal detail.url, ''
  end

  test "twitter handle" do
    detail = ContactDetails::Twitter.new 'arnaudlevy'
    assert_equal detail.label, 'arnaudlevy'
    assert_equal detail.url, 'https://twitter.com/arnaudlevy'
  end

  test "twitter twitter.com/arnaudlevy" do
    detail = ContactDetails::Twitter.new 'twitter.com/arnaudlevy'
    assert_equal detail.label, 'arnaudlevy'
    assert_equal detail.url, 'https://twitter.com/arnaudlevy'
  end

  test "twitter https://twitter.com/arnaudlevy" do
    detail = ContactDetails::Twitter.new 'https://twitter.com/arnaudlevy'
    assert_equal detail.label, 'arnaudlevy'
    assert_equal detail.url, 'https://twitter.com/arnaudlevy'
  end

  test "website nil" do
    detail = ContactDetails::Website.new nil
    assert_equal detail.label, ''
    assert_equal detail.url, ''
  end

  test "website www.noesya.coop" do
    detail = ContactDetails::Website.new 'www.noesya.coop'
    assert_equal detail.label, 'www.noesya.coop'
    assert_equal detail.url, 'https://www.noesya.coop'
  end

  test "website https://www.noesya.coop" do
    detail = ContactDetails::Website.new 'https://www.noesya.coop'
    assert_equal detail.label, 'www.noesya.coop'
    assert_equal detail.url, 'https://www.noesya.coop'
  end

end