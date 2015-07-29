module Pendant::Getter
  def []?(key)
  end

  def [](key)
  end

  def keys
  end

  # :nodoc:
  macro define_pendant_getters
    # :nodoc:
    module {{ "PendantGetter".id }}%mod
      macro included
        def []?(key)
          {% for m in @type.methods %}
            {% if m.args.length == 0 && m.name.stringify != "keys" && !m.name.stringify.starts_with?("__") %}
              if key == {{ m.name.stringify }} || key == :{{ m.name.stringify }}
                return self.{{ m.name }}
              end
            {% end %}
          {% end %}
          {% if @type.superclass && @type.superclass.methods.any?{|m| m.name.stringify == "[]?" && m.args.length == 1} %}
            super
          {% else %}
            nil
          {% end %}
        end

        def [](key)
          {% for m in @type.methods %}
            {% if m.args.length == 0 && m.name.stringify != "keys" && !m.name.stringify.starts_with?("__") %}
              if key == {{ m.name.stringify }} || key == :{{ m.name }}
                return self.{{ m.name }}
              end
            {% end %}
          {% end %}
          {% if @type.superclass && @type.superclass.methods.any?{|m| m.name.stringify == "[]?" && m.args.length == 1} %}
            super
          {% else %}
            # NOTE: `MissingKey` is deprected.  If next version Crystal is released, it renames to `KeyError`.
            raise MissingKey.new("Missing getter value: #{key.inspect}")
          {% end %}
        end

        # :nodoc:
        def __pendant_getter_keys
          m = {{ @type.methods.select do |m|
            m.args.length == 0 && m.name.stringify != "keys" && !m.name.stringify.starts_with?("__")
          end.map{|m| m.name.stringify}.uniq }} of String
          {% if @type.superclass && @type.superclass.methods.any?{|m| m.name.stringify == "keys" && m.args.length == 0} %}
            m.concat(super).uniq
          {% else %}
            m
          {% end %}
        end

        @@%keys = nil
        {% if @type.methods.any?{|m|m.name.stringify == "__pendant_setter_keys"} %}
          def keys
            return @@%keys.not_nil! if @@%keys
            @@%keys = self.__pendant_getter_keys.concat(self.__pendant_setter_keys).uniq
            @@%keys.not_nil!
          end
        {% else %}
          def keys
            return @@%keys.not_nil! if @@%keys
            @@%keys = self.__pendant_getter_keys
            @@%keys.not_nil!
          end
        {% end %}
      end
    end

    include {{ "PendantGetter".id }}%mod

    macro inherited
      define_pendant_getters
      {% if @type.methods.any?{|m|m.name.stringify == "__pendant_setter_keys"} %}
        define_pendant_setters
      {% end %}
    end

    macro included
      define_pendant_getters
      {% if @type.methods.any?{|m|m.name.stringify == "__pendant_setter_keys"} %}
        define_pendant_setters
      {% end %}
    end
  end

  # :nodoc:
  macro included
    define_pendant_getters
  end
end
