require 'rails_helper'

RSpec.describe "ErrorsController", type: :request do
  describe "GET /" do
    it "returns 404 not found" do
      get "/"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq({ "error" => "URL not found" })
    end
  end

  describe "GET /random" do
    it "returns 404 not found" do
      get "/random"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq({ "error" => "URL not found" })
    end
  end
end
