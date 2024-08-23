require 'swagger_helper'

RSpec.describe 'Osuny API' do

  path '/' do

    get 'Lists endpoints' do
      response '200', 'successful operation' do
        run_test!
      end
    end
  end
end