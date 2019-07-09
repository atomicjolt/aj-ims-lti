module AJIMS::LTI
  class XmlParseException < StandardError
    attr_reader :original_exception, :content
    def initialize(content, msg = "Failed to parse XML")
      super(msg)
      @content = content
    end

    def to_s
      error = super
      error << "\nDOCUMENT:\n#{@content}\nEND OF DOCUMENT\n"
      error
    end
  end
end
