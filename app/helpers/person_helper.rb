module PersonHelper
    def get_active_icon(person)
        icon = 'x-circle'
        color = 'text-danger'
        if person.active
            icon = 'check-circle'
            color = 'text-success'
        end

        icon_span = content_tag(:span, class: "#{color}") do
          content_tag(:i, '',class: "bi bi-#{icon}")
        end

        icon_span
    end
end
