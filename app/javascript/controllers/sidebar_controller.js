import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {

  connect() {
    const element = document.getElementById("sidebarToggle");
    element.innerHTML = "<<"
  }

  toggle() {
    document.body.classList.toggle('sb-sidenav-toggled');
    const element = document.getElementById("sidebarToggle");
    if (element.innerHTML == "&lt;&lt;") {
      element.innerHTML = ">>"
    } else {
      element.innerHTML = "<<"
    }
 }

}
