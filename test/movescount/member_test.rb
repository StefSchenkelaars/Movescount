require 'test_helper'

describe Movescount::Member do
  before { VCR.insert_cassette 'member', record: :new_episodes }
  after { VCR.eject_cassette }

  let(:email) { 'stef.schenkelaars@gmail.com' }
  let(:username) { 'StefSchenkelaars' }
  let(:userkey) { 'Ws55aENtjiprz3g' }
  let(:member) { Movescount::Member.new email: email, userkey: userkey }

  describe 'default attributes' do
    it 'must include httparty methods' do
      Movescount::Member.must_include HTTParty
    end
    it 'must have the base url set' do
      member.class.base_uri.must_equal 'https://uiservices.movescount.com'
    end
  end

  describe '#initialize' do
    it 'sets the options hash' do
      member.instance_variable_get(:@options).must_be_instance_of Hash
    end
    it 'sets the appKey in the query options' do
      member.instance_variable_get(:@options)[:query][:appKey].must_be_instance_of String
    end
    it 'sets the user key' do
      member.instance_variable_get(:@options)[:query][:userKey].must_equal userkey
    end
    it 'sets the user email' do
      member.instance_variable_get(:@options)[:query][:email].must_equal email
    end
  end

  describe '#profile' do
    it 'records' do
      member.profile.must_be_instance_of Hash
    end
    it 'returns the username' do
      member.profile['Username'].must_equal username
    end
    describe 'caching' do
      before do
        member.profile
        stub_request(:any, //).to_timeout
      end
      it 'must cache the profile' do
        member.profile.must_be_instance_of Hash
      end
      it 'must refresh the profile if forced' do
        lambda { member.profile(true) }.must_raise Net::OpenTimeout
      end
    end
  end

  describe '#username' do
    it 'returns the username from the profile call' do
      member.username.must_equal member.profile['Username']
    end
  end
end
