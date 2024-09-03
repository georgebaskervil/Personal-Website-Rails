# Pin npm packages by running ./bin/importmap
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "astro", to: "astro.js"
pin "core-js-custom", to: "core-js-custom-source.js"
pin "smoothscrolljs", to: "smoothscroll.js"