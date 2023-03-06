module Communication::Extranet::WithConnections
  extend ActiveSupport::Concern

  included do
    has_many :connections
  end
  
end