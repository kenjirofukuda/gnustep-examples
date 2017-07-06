package tutorial.webapp

import org.scalajs.dom
import org.scalajs.dom.document

import scala.scalajs.js.annotation.JSExportTopLevel
//import org.scalajs.jquery.jQuery


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

  def main(args: Array[String]): Unit = {
    appendPar(document.body, "Hello World3")
  }

  def main2(args: Array[String]): Unit = {
    println("Hello World")
  }
}
