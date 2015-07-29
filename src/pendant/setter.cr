module Pendant::Setter
  # :nodoc:
  macro define_pendant_setters
    module {{ "PendantSetter".id }}%mod
      macro included
        def []=(key, value)
          {% for m in @type.methods %}
            {% if m.args.length == 1 && m.name.stringify.ends_with?("=") && !m.name.stringify.starts_with?("__") %}
              if key == {{ (s = m.name.stringify; s[0..-2]) }} || key == :{{ (s = m.name.stringify; s[0..-2]) }}
                self.{{ m.name }}(value)
                return value
              end
            {% end %}
          {% end %}
          {% if @type.superclass && @type.superclass.methods.any?{|m| m.name.stringify == "[]=" && m.args.length == 2} %}
            super
          {% else %}
            raise MissingKey.new("")
          {% end %}
        end

        def __pendant_setter_keys
          m = {{ @type.methods.select do |m|
            m.args.length == 1 && m.name.stringify.ends_with?("=") && m.name.stringify != "keys" && !m.name.stringify.starts_with?("__")
          end.map{|m| s =m.name.stringify; s[0..-2] }.uniq }} of String
          {% if @type.superclass && @type.superclass.methods.any?{|m| m.name.stringify == "keys" && m.args.length == 0} %}
            m.concat(super).uniq
          {% else %}
            m
          {% end %}
        end

        {% if @type.methods.any?{|m|m.name.stringify == "__pendant_getter_keys"} %}
          def keys
            self.__pendant_setter_keys.concat(self.__pendant_getter_keys).uniq
          end
        {% else %}
          def keys
            self.__pendant_setter_keys
          end
        {% end %}
      end
    end

    include {{ "PendantSetter".id }}%mod

    macro inherited
      define_pendant_setters
      {% if @type.methods.any?{|m|m.name.stringify == "__pendant_getter_keys"} %}
        define_pendant_getters
      {% end %}
    end

    macro included
      define_pendant_setters
      {% if @type.methods.any?{|m|m.name.stringify == "__pendant_getter_keys"} %}
        define_pendant_getters
      {% end %}
    end
  end

  # :nodoc:
  macro included
    define_pendant_setters
  end
end
