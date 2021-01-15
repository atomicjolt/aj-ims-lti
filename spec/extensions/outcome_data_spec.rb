require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe AJIMS::LTI::Extensions do
  before do
    create_params
    @params['ext_outcome_data_values_accepted'] = 'text'
    @tp = AJIMS::LTI::ToolProvider.new("hi", 'oi', @params)
    @tp.extend AJIMS::LTI::Extensions::OutcomeData::ToolProvider
  end

  it "should correctly check supported data fields" do
    @tp.accepts_outcome_data?.should == true
    @tp.accepts_outcome_text?.should == true
    @tp.accepts_outcome_url?.should == false
  end
  
  it "should add TC functionality" do
    tc = AJIMS::LTI::ToolConsumer.new("hey", "ho")
    tc.extend AJIMS::LTI::Extensions::OutcomeData::ToolConsumer
    tc.support_outcome_data!
    tc.outcome_data_values_accepted.should == 'text,url'
    tc.outcome_data_values_accepted = 'url,text'
    tc.outcome_data_values_accepted.should == 'url,text'
    tc.outcome_data_values_accepted = %w{text url}
    tc.outcome_data_values_accepted.should == 'text,url'
    tc.to_params['ext_outcome_data_values_accepted'].should == 'text,url'
  end

  it "should generate an extended outcome text request" do
    xml = result_xml % %{<resultScore><language>en</language><textString>.5</textString></resultScore><resultData><text>the text</text></resultData>}
    mock_request(xml)
    
    @tp.post_replace_result_with_data!('.5', "text" => "the text")
  end

  it "should generate an extended outcome text request using cdata" do
    xml = result_xml % %{<resultScore><language>en</language><textString>.5</textString></resultScore><resultData><text><![CDATA[the text]]></text></resultData>}
    mock_request(xml)
    
    @tp.post_replace_result_with_data!('.5', "cdata_text" => "the text")
  end

  it "should generate an extended outcome url request" do
    xml = result_xml % %{<resultData><url>http://www.example.com</url></resultData>}
    mock_request(xml)
    
    @tp.post_replace_result_with_data!(nil, "url" => "http://www.example.com")
  end

  it "should generate an extended outcome file request" do
    xml = result_xml % %{<resultData><downloadUrl>http://www.example.com</downloadUrl><documentName>what the document</documentName></resultData>}
    mock_request(xml)
    
    @tp.post_replace_result_with_data!(nil, "download_url" => "http://www.example.com", "document_name" => "what the document")
  end
  
  it "should parse replaceResult xml with extension val" do
    req = AJIMS::LTI::OutcomeRequest.new
    req.extend AJIMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><url>http://www.example.com</url></resultData>})
    req.outcome_url.should == "http://www.example.com"
  end
  
  it "should parse replaceResult xml with extension val" do
    req = AJIMS::LTI::OutcomeRequest.new
    req.extend AJIMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><text>what the text</text></resultData>})
    req.outcome_text.should == "what the text"
  end
  
  it "should parse replaceResult xml with extension val" do
    req = AJIMS::LTI::OutcomeRequest.new
    req.extend AJIMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><text>what the text</text></resultData>})
    req.outcome_text.should == "what the text"
  end

  it "should parse replaceResult xml with extension val" do
    req = AJIMS::LTI::OutcomeRequest.new
    req.extend AJIMS::LTI::Extensions::OutcomeData::OutcomeRequest
    req.process_xml(result_xml % %{<resultData><downloadUrl>http://www.example.com</downloadUrl><documentName>what the document</documentName></resultData>})
    req.outcome_download_url.should == "http://www.example.com"
    req.outcome_document_name.should == "what the document"
  end
end
