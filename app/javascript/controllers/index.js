import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import CalendarController from "./calendar_controller"
application.register("calendar", CalendarController)
