pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "preact" # @10.12.1
pin "preact/compat", to: "preact--compat.js" # @10.12.1
pin "preact/hooks", to: "preact--hooks.js" # @10.12.1

pin "@fullcalendar/core", to: "fullcalendar-core.js"
pin "@fullcalendar/daygrid", to: "fullcalendar-daygrid.js"
pin "@fullcalendar/interaction", to: "fullcalendar-interaction.js"