require 'rails_helper'

RSpec.describe UrlDecodeService do
  let(:domain) { "http://localhost:3000" }

  describe "#call" do
    context "when URL has invalid domain" do
      let(:url) { "http:/localost:4000/abc123" }

      it "raises InvalidDomainError" do
        expect { described_class.call(url) }.to raise_error(UrlDecodeService::InvalidDomainError)
      end
    end

    context "when short link does not exist" do
      let(:url) { "#{domain}/abc123" }

      it "raises UrlNotFoundError" do
        expect { described_class.call(url) }.to raise_error(UrlDecodeService::UrlNotFoundError)
      end
    end
  end
end
