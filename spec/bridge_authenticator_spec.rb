require "spec_helper"

describe "BridgeAuthenticator" do
  let(:app) { mock "app" }
  let(:auth) { Appvault::FaradayMiddleware::Auth.new(app, "123456") }

  before(:each) do
    Appvault::FaradayMiddleware::Auth.stub!(:super => true)
    app.stub(:call => true)
  end

  context "intialize" do
    it "should assign key_id" do
      auth.key_id.should == "123456"
    end
  end

  context "signed_api_fingerprint" do
    before(:each) do
      crypto = mock "Crypto", :detach_sign => "Signature"
      GPGME::Crypto.stub!(:new => crypto)
    end

    it "should remove all \n from signature" do
      encoded_signature = auth.signed_api_fingerprint("headers", "env", "key_id")
      encoded_signature.should == Base64.encode64("Signature").gsub(/\n/, "")
    end
  end

  context "api_fingerprint" do
    it "should return correct fingerprint" do
      fingerprint = auth.api_fingerprint({ "X-Api-Timestamp" => "1369370612.5185978" }, { "body" => "body" })
      fingerprint.should == "1369370612.5185978\nbody"
    end

    it "should return correct fingerprint when no body" do
      fingerprint = auth.api_fingerprint({ "X-Api-Timestamp" => "1369370612.5185978" }, { "body" => "" })
      fingerprint.should == "1369370612.5185978\n"
    end
  end

  context "call" do
    let(:env) { {:request_headers => {} } }

    before(:each) do
      Time.stub_chain(:now, :to_f, :to_s).and_return("1369370612.5185978")
      Base64.stub!(:encode64 => "Signature")
      auth.call(env)
    end


    it "should assign correct Timestamp" do
      env[:request_headers]["X-Api-Timestamp"].should == "1369370612.5185978"
    end

    it "should assign correct Key ID" do
      env[:request_headers]["X-Api-Key-Id"].should == "123456"
    end

    it "should assign correct Signature" do
      env[:request_headers]["X-Api-Signature"].should == "Signature"
    end
  end
end

