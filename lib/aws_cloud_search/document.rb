module AwsCloudSearch
  class Document

    # A typed attribute accessor helper. When the value is set, if it does not match
    # the pre-defined type, an exception is thrown.
    # @param [String] name Name of the attribute
    # @param [Class] type The class type of the attribute
    def self.type_attr_accessor(name, type)
      define_method(name) do
        instance_variable_get("@#{name}")
      end

      define_method("#{name}=") do |value|
        if value.is_a? type or value == nil
          instance_variable_set("@#{name}", value)
        else
          raise ArgumentError.new("Invalid Type")
        end
      end
    end

    type_attr_accessor :version, Integer
    type_attr_accessor :lang, String
    attr_accessor :type
    attr_reader :fields, :id

    # Initializes the object
    # @param [boolean] auto_version Set to true to automatically set the version, default is false
    def initialize(auto_version=false)
      @fields = {}
      new_version if auto_version
    end

    # Adds a new field to the document
    # @param [String] name Name of the document field
    # @param [String, Integer] value Value of the document field
    def add_field(name, value)
      @fields[name] = value
    end

    # The id field must conform to a special format
    def id=(id)
      if id.is_a? String
        raise ArgumentError.new("Document id must match the regex [a-z0-9][a-z0-9_]*$") unless id =~ /^[a-z0-9][a-z0-9_]*$/
        @id = id.downcase
      elsif id == nil
        @id = id
      else
        raise ArgumentError.new("Invalid Type")
      end
    end

    # Resets the fields.
    def clear_fields
      @fields = {}
    end

    # Set a new version automatically
    def new_version
      @version = Time.now.to_i
    end

    # Return this object as a hash
    def to_hash
      {
          :type => @type,
          :id => @id,
          :version => @version,
          :lang => @lang,
          :fields => @fields
      }
    end

  end
end