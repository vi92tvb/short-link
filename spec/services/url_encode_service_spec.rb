require 'rails_helper'

RSpec.describe UrlEncodeService, type: :service do
  describe '.call' do
    let(:url) { 'https://example.com' }

    context 'when the number of generated codes is less than or equal to 62^6' do
      it 'generates a short code with exactly 6 characters' do
        10.times do |i|
          test_url = "#{url}/#{i}"
          short_code = UrlEncodeService.call(test_url)
          puts "\nGenerated short code for #{test_url}: #{short_code}\n"

          expect(short_code.length).to eq(6)
        end
      end
    end

    context 'when the number of generated codes exceeds 62^6' do
      it 'generates a short code with more than 6 characters' do
        large_number_of_codes = 62**6 + 1
        
        counter = Counter.find_or_create_by(name: 'total_codes')
        counter.update!(count: large_number_of_codes)
        
        short_code = UrlEncodeService.call(url)
        
        puts "\nGenerated short code for #{url}: #{short_code}\n"

        expect(short_code.length).to be > 6
      end
    end
  end
end
