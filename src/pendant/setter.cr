module Pendant::Setter
  # Set a `value` calling `key=(value)` method.
  # If not defined `key=(value)` method, it raise `KeyError`.
  def []=(key, value); end

  # It returns available keys.
  # A name of keys ends with '=' and length of its arguments is `1` (except `[]=`).
  def keys; end

  # It defines `[]=` and `keys` into your class directory.
  # Included `Pendant::Setter`, it calls via hooks.
  #
  # Defining methods use methods information in the moment,
  # so please call this macro if you define a new method after including.
  macro define_pendant_setters

    # See `Pendant::Setter#[]=`
    def []=(key, value : T)
      {% for m in @type.methods %}
        {% if m.args.length == 1 && m.name.stringify.ends_with?("=") %}
          if key == {{ m.name.stringify[0..-2] }} || key == :{{ m.name.stringify[0..-2] }}
            return self.{{ m.name }}(value)
          end
        {% end %}
      {% end %}

      {% if @type.superclass && @type.superclass.methods.any?{|m|m.name.stringify == "[]=" && m.args.length == 2} %}
        super
      {% else %}
        raise KeyError.new "Missing key value: #{key.inspect}"
      {% end %}
    end

    @@%keys = nil

    # See `Pendant::Setter#keys`
    def keys
      if keys = @@%keys
        keys
      else
        keys = {{ @type.methods.select do |m|
          m.args.length == 1 && m.name.ends_with?("=")
        end.map{|m|m.name.stringify[0..-2]} }} of String

        {% if @type.methods.any?{|m|m.name.stringify == "keys" && m.args.length == 0} %}
          keys.concat(previous_def)
        {% end %}
        {% if @type.superclass && @type.superclass.methods.any?{|m|m.name.stringify == "keys" && m.args.length == 0} %}
          keys.concat(super)
        {% end %}
        keys.uniq!
        @@%keys = keys
        keys
      end
    end

    macro inherited
      define_pendant_setters
    end

    macro included
      define_pendant_setters
    end
  end

  macro included
    define_pendant_setters
  end
end
