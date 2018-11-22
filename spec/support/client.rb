shared_examples 'a client' do
  describe 'when the session id expires' do
    let(:exception) { Savon::SOAPFault.new(HTTPI::Response.new(403, {}, ''), nori) }
    let(:nori) { Nori.new(:strip_namespaces => true, :convert_tags_to => lambda { |tag| tag.snakecase.to_sym }) }

    before do
      allow(exception).to receive(:message).and_return('INVALID_SESSION_ID')
    end

    context 'and no authentication handler is present' do
      before do
        allow(client).to receive(:authentication_handler).and_return(nil)
      end

      it 'raises the exception' do
        allow(client).to receive(:perform_request).once.and_raise(exception)

        expect { client.send(:request, :foo) }.to raise_error(exception)
      end
    end

    context 'and an authentication handler is present' do
      let(:handler) do
        proc { |client, options| { :session_id => 'foo' }  }
      end

      before do
        allow(client).to receive(:authentication_handler).and_return(handler)
      end

      it 'calls the authentication handler and resends the request' do
        response = double('response')
        allow(response).to receive(:body).and_return(Hashie::Mash.new(:foo_response => {:result => ''}))

        call_count = 0
        allow(client).to receive(:perform_request) {
          call_count += 1
          call_count == 1 ? (raise exception) : response
        }

        expect(handler).to receive(:call).and_call_original
        client.send(:request, :foo)
        expect(client.send(:client).globals[:soap_header]).to eq("tns:SessionHeader"=>{"tns:sessionId"=>"foo"})
      end
    end
  end
end
