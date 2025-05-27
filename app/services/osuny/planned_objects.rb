class Osuny::PlannedObjects
  def self.manage
    touch_all Communication::Website::Agenda::Event
    touch_all Communication::Website::Agenda::Exhibition
    touch_all Communication::Website::Post
  end

  protected

  def self.touch_all(klass)
    klass.find_each(&:touch)
  end
end