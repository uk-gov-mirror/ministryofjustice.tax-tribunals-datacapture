require 'rails_helper'

RSpec.describe Steps::DisputeTypeController, type: :controller do
    it_behaves_like 'an intermediate step controller', DisputeTypeForm
end
