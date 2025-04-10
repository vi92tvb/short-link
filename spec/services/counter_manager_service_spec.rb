require 'rails_helper'

RSpec.describe CounterManagerService do
  describe "#call" do
    let(:counter) { Counter.find_or_create_by(name: "total_codes") }

    before do
      counter.update(count: 0)
    end

    it "increments the counter by 1" do
      expect {
        described_class.call
      }.to change { counter.reload.count.to_i }.by(1)
    end

    it "returns at least the minimum token length" do
      result = described_class.call
      expect(result).to be >= CounterManagerService::MIN_TOKEN_LENGTH
    end

    it "returns correct token length based on total count" do
      counter.update(count: 61)
      result = described_class.call
      expected_length = [ 2, CounterManagerService::MIN_TOKEN_LENGTH ].max
      expect(result).to eq(expected_length)
    end

    context "when update fails" do
      it "logs the error and raises it" do
        allow_any_instance_of(Counter).to receive(:update!).and_raise(StandardError, "DB failure")

        expect(Rails.logger).to receive(:error).with(/Failed to update the counter: DB failure/)

        expect {
          described_class.call
        }.to raise_error(StandardError, "DB failure")
      end
    end
  end
end
