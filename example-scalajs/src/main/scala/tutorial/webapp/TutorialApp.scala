package tutorial.webapp

import gds.geometry.{HVPoint, Viewport}
import org.scalajs.dom
import org.scalajs.dom.document

import scala.scalajs.js.annotation.JSExportTopLevel
import org.scalajs.jquery.jQuery


object TutorialApp {
  @JSExportTopLevel("addClickedMessage")
  def addClickedMessage(): Unit = {
    appendPar(document.body, "You clicked the button!")
  }

  def appendPar(targetNode: dom.Node, text: String): Unit = {
    val parNode = document.createElement("p")
    val textNode = document.createTextNode(text)
    parNode.appendChild(textNode)
    targetNode.appendChild(parNode)
  }

  def setupUI(): Unit = {
    val viewport = new Viewport
    viewport.center = HVPoint(20, 50)
    appendPar(document.body, "Hello World8 " + viewport.center)
    jQuery("body").append("<p>[Message]</p>")
    appendPar(document.body, "Hello World12 " + viewport.size)
    jQuery("#click-me-button").click(() => addClickedMessage())
//    jQuery("body").append("<p>Hello World</p>")
  }

  def main(args: Array[String]): Unit = {
    jQuery(() => setupUI())
  }
}
