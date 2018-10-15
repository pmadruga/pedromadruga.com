=begin
Jekyll plugin to obfuscate email addresses.

Copyright (C) 2016  Paolo Smiraglia <paolo.smiraglia@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end

module Jekyll
    class EmailTag < Liquid::Tag
        SPAN_CLASS = "o3m41l"
        MAILTO = '&#109;ai&#108;to&#58;'
        AT = 'varaiRi8'
        DOT = 'chie6Aet'
        DASH = 'oaPoo7eo'
        UNDERSCORE = 'Oe8eed6M'

        def initialize(tag_name, text, tokens)
            super
            @email = text
        end

        def render(context)
            values = @email.split("@")
            data_user = values[0]
            data_domain = values[1]
            obfuscated = encode(@email)

            at = saltify(AT)
            dot = saltify(DOT)
            underscore = saltify(UNDERSCORE)
            dash = saltify(DASH)

            "<a href=\"#{MAILTO}#{obfuscated}\" " +
                "onmouseover=\"this.href=this.href" +
                    ".replace(/#{at}/,'&#64;')" +
                    ".replace(/#{dot}/g,'&#46;')" +
                    ".replace(/#{underscore}/g,'&#95;')" +
                    ".replace(/#{dash}/g,'&#45;')\">" +
            "<span class=\"#{SPAN_CLASS}\" " +
                "data-x=\"#{data_user}\" " +
                "data-y=\"#{data_domain}\"></span>" +
            "</a>"
        end

        def encode(s)
            s = s.gsub("@", saltify(AT))
            s = s.gsub(".", saltify(DOT))
            s = s.gsub("-", saltify(DASH))
            s = s.gsub("_", saltify(UNDERSCORE))
        end

        def saltify(s)
            "&#123;" + s + "&#126;"
        end

        private :saltify, :encode
    end
end

Liquid::Template.register_tag('email', Jekyll::EmailTag)
