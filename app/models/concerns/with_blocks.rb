module WithBlocks
  extend ActiveSupport::Concern

  included do
    has_many :blocks, as: :about
  end
end
