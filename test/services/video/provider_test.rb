require "test_helper"

class Video::ProviderTest < ActiveSupport::TestCase

  def test_provider_empty
    provider = Video::Provider.find('')
    assert_equal Video::Provider::Default, provider.class
  end

  def test_vimeo
    provider = Video::Provider.find('https://vimeo.com/248482251')
    assert_equal Video::Provider::Vimeo, provider.class
  end

  def test_youtube
    provider = Video::Provider.find('https://www.youtube.com/watch?v=sN8Cq5HEBug')
    assert_equal Video::Provider::Youtube, provider.class
    provider = Video::Provider.find('https://youtu.be/sN8Cq5HEBug')
    assert_equal Video::Provider::Youtube, provider.class
  end

  def test_dailymotion
    provider = Video::Provider.find('https://www.dailymotion.com/video/x35l6b8')
    assert_equal Video::Provider::Dailymotion, provider.class
    provider = Video::Provider.find('https://dai.ly/x35l6b8')
    assert_equal Video::Provider::Dailymotion, provider.class
  end

  def test_peertube
    provider = Video::Provider.find('https://peertube.fr/w/1i848Qvi7Q3ytW2uPY8AxG')
    assert_equal Video::Provider::Peertube, provider.class
    provider = Video::Provider.find('https://peertube.my.noesya.coop/w/qBMwAAULLA9oadFgbtdyq8')
    assert_equal Video::Provider::Peertube, provider.class
  end
end