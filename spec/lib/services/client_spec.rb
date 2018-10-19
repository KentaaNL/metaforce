require 'spec_helper'

describe Metaforce::Services::Client do
  let(:client) { described_class.new(:session_id => 'foobar', :server_url => 'https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh') }

  it_behaves_like 'a client'

  describe '.describe_layout' do
    context 'without a record type id' do
      before do
        body = File.read("spec/fixtures/requests/describe_layout/success.xml")
        stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
      end

      subject { client.describe_layout('Account') }
      it { should be_a Hash }
    end

    context 'with a record type id' do
      before do
        body = File.read("spec/fixtures/requests/describe_layout/success.xml")
        stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
      end

      subject { client.describe_layout('Account', '1234') }
      it { should be_a Hash }
    end
  end

  describe '.send_email' do
    before do
      body = File.read("spec/fixtures/requests/send_email/success.xml")
      stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
    end

    subject { client.send_email(:to_addresses => 'foo@bar.com', subject: 'foo', plain_text_body: 'bar') }
    it { should be_a Hash}
  end
end
