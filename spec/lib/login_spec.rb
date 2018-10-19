require 'spec_helper'

describe Metaforce::Login do
  let(:klass) { described_class.new('foo', 'bar', 'whizbang') }

  describe '.login' do
    before do
      body = File.read("spec/fixtures/requests/login/success.xml")
      stub_request(:post, "https://login.salesforce.com/services/Soap/u/30.0").to_return(status: 200, body: body)
    end

    subject { klass.login }
    it { should be_a Hash }
    its([:session_id])          { should eq '00DU0000000Ilbh!AQoAQHVcube9Z6CRlbR9Eg8ZxpJlrJ6X8QDbnokfyVZItFKzJsLH' \
                                  'IRGiqhzJkYsNYRkd3UVA9.s82sbjEbZGUqP3mG6TP_P8' }
    its([:metadata_server_url]) { should eq 'https://na12-api.salesforce.com/services/Soap/m/23.0/00DU0000000Albh' }
    its([:server_url])          { should eq 'https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh' }
  end
end
