require 'spec_helper'

describe KickboxRails do
  subject { KickboxRails.new }

  describe "Configuration" do
    before do
      KickboxRails.configure do |config|
        config.api_key = 'example_key'
        config.api_url = 'http://example-url.com/'
        config.api_resource = 'v1/resource'
      end
    end

    it 'is configurable' do
      expect(KickboxRails.configuration.api_key).to eq('example_key')
      expect(KickboxRails.configuration.api_url).to eq('http://example-url.com/')
      expect(KickboxRails.configuration.api_resource).to eq('v1/resource')
    end
  end

  describe "Email" do

    let(:valid_email) { "example@gmail.com" }
    let(:invalid_email) { "examplemail.com" }
    let(:valid_result) { Hash['result','valid'] }
    let(:invalid_result) { Hash['result','invalid','reason','invalid_email'] }
    let(:valid_service_result) do
      {
        "result" => "valid",
        "reason" => "accepted_email",
        "role" => false,
        "free" => false,
        "disposable" => false,
        "accept_all" => true,
        "did_you_mean" => nil,
        "sendex" => 0.9,
        "email" => "example@gmail.com",
        "user" => "example",
        "domain" => "gmail.com",
        "success" => true,
        "message" => nil
      }
    end

    let(:invalid_service_result) do
      {
        "result" => "invalid",
        "reason" => "rejected_email",
        "role" => false,
        "free" => false,
        "disposable" => false,
        "accept_all" => false,
        "did_you_mean" => "example@gmail.com",
        "sendex" => "0",
        "email" => "example@gamil.com",
        "user" => "example",
        "domain" => "gamil.com",
        "success" => true,
        "message" => nil
      }
    end

    let(:error_service_result) do
      {
        "success" => false,
        "message" => "No email address defined"
      }
    end

    it 'is valid with basic validation' do
      expect(KickboxRails.validate(valid_email)).to eq(valid_result)
    end

    it 'is invalid with basic validation' do
      expect(KickboxRails.validate(invalid_email)).to eq(invalid_result)
    end

    it 'is invalid with nil parameter' do
      expect(KickboxRails.validate(nil)).to eq(invalid_result)
    end

    it 'is valid with service validation' do
      allow(KickboxRails.provider).to receive(:verify).and_return(valid_service_result)
      expect(KickboxRails.validate(valid_email)).to eq(valid_service_result)
    end

    it 'is invalid with service validation' do
      allow(KickboxRails.provider).to receive(:verify).and_return(invalid_service_result)
      expect(KickboxRails.validate(valid_email)).to eq(invalid_service_result)
    end

    it 'fallbacks to valid on service error ' do
      allow(KickboxRails.provider).to receive(:verify).and_return(error_service_result)
      expect(KickboxRails.validate(valid_email)).to eq(valid_result)
    end

    it 'fallbacks to invalid on service error ' do
      allow(KickboxRails.provider).to receive(:verify).and_return(error_service_result)
      expect(KickboxRails.validate(invalid_email)).to eq(invalid_result)
    end

    it 'fallbacks to invalid on nil value and service error ' do
      allow(KickboxRails.provider).to receive(:verify).and_return(error_service_result)
      expect(KickboxRails.validate(nil)).to eq(invalid_result)
    end

    it 'is valid? eq true' do
      expect(KickboxRails.valid?(valid_email)).to eq(true)
    end

    it 'is valid? eq false' do
      expect(KickboxRails.valid?(invalid_email)).to eq(false)
    end

    it 'is valid? eq false with nil parameter' do
      expect(KickboxRails.valid?(nil)).to eq(false)
    end
  end
end
