require "json"

module AWSCloudSearch
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
      raise ArgumentError.new("Found invalid XML 1.0 unicode character(s)") if value.is_a? String and value =~ INVALID_CHAR_XML10
      @fields[name] = value
    end

    # The id field must conform to a special format
    def id=(id)
      raise ArgumentError.new("Invalid ID: Document id must be a String or respond to #to_s") if (id.nil? || !id.respond_to?(:to_s))
      @id = id.to_s
      raise ArgumentError.new("Invalid ID: Document id must match the regex [a-z0-9][a-z0-9_]*$") unless @id =~ /^[a-z0-9][a-z0-9_]*$/
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
      @fields.delete_if {|key,val| val.nil?}
      h = {
          :type => @type,
          :id => @id,
          :version => @version
      }

      unless @type == 'delete'
        h[:fields] = @fields 
        h[:lang] = @lang
      end

      h      
    end

    #Return this object as json
    def to_json
      to_hash.to_json
    end

  end
end
