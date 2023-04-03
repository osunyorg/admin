module WithReferences
  extend ActiveSupport::Concern

  def references
    raise NotImplementedError
  end
end