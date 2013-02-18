shared_examples 'an authenticated action' do
  context 'when not authenticated' do
    before { UserAuthenticator.any_instance.stub(:authenticated?).and_return(false) }

    it 'should respond with 401 Unauthorized' do
      call_action
      expect(response.code).to eq('401')
    end
  end
end

shared_examples 'an administrator action' do
  context 'when authenticated as a normal user' do
    before do
      UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
      UserAuthenticator.any_instance.stub(:administrator?).and_return(false)
    end

    it 'should respond with 401 Unauthorized' do
      call_action
      expect(response.code).to eq('401')
    end
  end
end

