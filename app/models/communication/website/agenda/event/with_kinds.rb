module Communication::Website::Agenda::Event::WithKinds
  extend ActiveSupport::Concern

  def can_have_children?
    parent.nil?
  end
end
