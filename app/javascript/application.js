// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
Turbo.session.drive = false
import jQuery from "jquery"
window.jQuery = jQuery
window.$ = jQuery
