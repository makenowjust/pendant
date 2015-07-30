module Pendant::Getter
  macro define_pendant_getters
    def []?(key)
      {% for m in @type.methods %}
        {% if m.args.length == 0 && m.name.stringify != "keys" %}
          if key == {{ m.name.stringify }} || key == :{{ m.name.stringify }}
            return self.{{ m.name }}
          end
        {% end %}
      {% end %}

      {% if @type.superclass && @type.superclass.methods.any?{|m|m.name.stringify == "[]?" && m.args.length == 1} %}
        super
      {% else %}
        nil
      {% end %}
    end

    def [](key)
      {% for m in @type.methods %}
        {% if m.args.length == 0 && m.name.stringify != "keys" %}
          if key == {{ m.name.stringify }} || key == :{{ m.name.stringify }}
            return self.{{ m.name }}
          end
        {% end %}
      {% end %}

      {% if @type.superclass && @type.superclass.methods.any?{|m|m.name.stringify == "[]" && m.args.length == 1} %}
        super
      {% else %}
        raise KeyError.new "Missing key value: #{key.inspect}"
      {% end %}
    end

    @@%keys = nil
    def keys
      if keys = @@%keys
        keys
      else
        keys = {{ @type.methods.select do |m|
          m.args.length == 0 && m.name.stringify != "keys"
        end.map{|m|m.name.stringify} }} of String

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
      define_pendant_getters
    end

    macro included
      define_pendant_getters
    end
  end

  macro included
    define_pendant_getters
  end
end
