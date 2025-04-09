require 'rails_helper'

RSpec.describe ShortLinksController, type: :controller do
  describe 'POST #encode' do
    let(:url) { 'https://example.com/abcdef' }
    let(:app_domain) { 'http://localhost:3000.com' }

    before do
      # Set the APP_DOMAIN environment variable for the test
      allow(ENV).to receive(:[]).with('APP_DOMAIN').and_return(app_domain)
    end

    it 'returns a short URL with the domain' do
      post :encode, params: { short_link: { url: url } }

      expect(response).to have_http_status(:success)
      short_url = JSON.parse(response.body)['short_url']
      expect(short_url).to start_with(app_domain)
      expect(short_url).to end_with(ShortLink.last.code)
    end

    it 'creates a short link record in the database' do
      expect {
        post :encode, params: { short_link: { url: url } }
      }.to change(ShortLink, :count).by(1)
    end
  end

  describe 'POST #decode' do
    let(:url) { 'https://example.com/abcdef' }
    let(:short_code) { 'abc123' }

    before do
      ShortLink.create!(origin_url: url, code: short_code)
    end

    it 'returns the original URL when given a valid short code' do
      post :decode, params: { short_link: { code: short_code } }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['url']).to eq(url)
    end

    it 'returns an error when given an invalid short code' do
      post :decode, params: { short_link: { code: 'invalidcode' } }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('URL not found')
    end
  end

  describe 'GET #redirect' do
    let(:url) { 'https://example.com/abcdef' }
    let(:short_code) { 'abc123' }
    let!(:short_link) { ShortLink.create!(origin_url: url, code: short_code) }

    it 'redirects to the original URL' do
      get :redirect, params: { short_url: short_code }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(url)
    end

    it 'returns an error if the short code is invalid' do
      get :redirect, params: { short_url: 'invalidcode' }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('URL not found')
    end
  end
end
