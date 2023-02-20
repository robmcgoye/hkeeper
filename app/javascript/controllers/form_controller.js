import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = [ "source" ]

  submit() {
    // this.element.submit();
    const element = document.getElementById("source");
    element.submit();
    console.log("hello");
  }
}