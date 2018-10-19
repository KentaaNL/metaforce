require 'spec_helper'

describe Metaforce::Metadata::Client do
  let(:client) { described_class.new(:session_id => 'foobar', :metadata_server_url => 'https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh') }

  it_behaves_like 'a client'

  describe '.list_metadata' do
    context 'with a single symbol' do
      before do
        body = File.read("spec/fixtures/requests/list_metadata/objects.xml")
        stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
      end

      subject { client.list_metadata(:apex_class) }
      it { should be_an Array }
    end

    context 'with a single string' do
      before do
        body = File.read("spec/fixtures/requests/list_metadata/objects.xml")
        stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
      end

      subject { client.list_metadata('ApexClass') }
      it { should be_an Array }
    end
  end

  describe '.describe' do
    context 'with no version' do
      before do
        body = File.read("spec/fixtures/requests/describe_metadata/success.xml")
        stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
      end

      subject { client.describe }
      it { should be_a Hash }
    end

    context 'with a version' do
      before do
        body = File.read("spec/fixtures/requests/describe_metadata/success.xml")
        stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
      end

      subject { client.describe('18.0') }
      it { should be_a Hash }
    end
  end

  describe '.status' do
    context 'with a single id' do
      before do
        body = File.read("spec/fixtures/requests/check_status/done.xml")
        stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
      end

      subject { client.status '1234' }
      it { should be_a Hash }
    end
  end

  describe '._deploy' do
    before do
      body = File.read("spec/fixtures/requests/deploy/in_progress.xml")
      stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
    end

    subject { client._deploy('foobar') }
    it { should be_a Hash }
  end

  describe '.deploy' do
    subject { client.deploy File.expand_path('../../path/to/zip') }
    it { should be_a Metaforce::Job::Deploy }
  end

  describe '._retrieve' do
    let(:options) { double('options') }

    before do
      body = File.read("spec/fixtures/requests/retrieve/in_progress.xml")
      stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
    end

    subject { client._retrieve(options) }
    it { should be_a Hash }
  end

  describe '.retrieve' do
    subject { client.retrieve }
    it { should be_a Metaforce::Job::Retrieve }
  end

  describe '.retrieve_unpackaged' do
    let(:manifest) { Metaforce::Manifest.new(:custom_object => ['Account']) }
    subject { client.retrieve_unpackaged(manifest) }
    it { should be_a Metaforce::Job::Retrieve }
  end

  describe '._create' do
    before do
      body = File.read("spec/fixtures/requests/create/in_progress.xml")
      stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
    end

    subject { client._create(:apex_component, :full_name => 'component', :label => 'test', :content => 'foobar') }
    it { should be_a Hash }
  end

  describe '._delete' do
    context 'with a single name' do
      before do
        body = File.read("spec/fixtures/requests/delete/in_progress.xml")
        stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
      end

      subject { client._delete(:apex_component, 'component') }
      it { should be_a Hash }
    end

    context 'with multiple' do
      before do
        body = File.read("spec/fixtures/requests/delete/in_progress.xml")
        stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
      end

      subject { client._delete(:apex_component, 'component1', 'component2') }
      it { should be_a Hash }
    end
  end

  describe '._update' do
    before do
      body = File.read("spec/fixtures/requests/update/in_progress.xml")
      stub_request(:post, "https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh").to_return(status: 200, body: body)
    end

    subject { client._update(:apex_component, 'old_component', :full_name => 'component', :label => 'test', :content => 'foobar') }
    it { should be_a Hash }
  end
end



