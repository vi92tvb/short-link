require 'rails_helper'

RSpec.describe ShortLinkGeneratorService do
  let(:url) { "https://example.com" }

  describe "#call" do
    before do
      allow(CounterManagerService).to receive(:call).and_return(6)
      allow(Time).to receive(:now).and_return(Time.at(1_700_000_000))
    end

    it "creates a short link and returns the short code" do
      expect {
        short_code = described_class.call(url)

        expect(short_code).to be_present
        short_link = ShortLink.find_by(code: short_code)
        expect(short_link).not_to be_nil
        expect(short_link.origin_url).to eq(url)
      }.to change { ShortLink.count }.by(1)
    end

    context "when short link creation fails" do
      before do
        allow(ShortLink).to receive(:create!).and_raise(StandardError.new("DB failure"))
      end
      it "raises the error" do
        expect {
          described_class.call(url)
        }.to raise_error(StandardError, "DB failure")
      end
    end
  end
end
