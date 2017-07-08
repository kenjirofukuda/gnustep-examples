package gds.geometry


/**
  * Created by kenjiro on 2017/07/08.
  */

case class Point[T](x: T, y: T) (implicit num: Numeric[T]) {
  import Numeric.Implicits._
  def /(v: Double): Point[T] = new Point((x.toDouble / v).asInstanceOf[T], (y.toDouble / v).asInstanceOf[T])

}


object HVPoint {
  def apply(x: Int, y:Int): Point[Int] = new Point[Int](x, y)
}

object XYPoint {
  def apply(x: Double, y:Double): Point[Double] = new Point[Double](x, y)
}

//case class XYPoint(x: Double, y: Double)


class Viewport() {
  private var _size: Point[Int] = HVPoint(0, 0)
  private var _center: Point[Int] = HVPoint(0, 0)
  private var _worldCenter: Point[Double] = XYPoint(0, 0)
  private var _worldScale: Double = 0.0

  def size_=(size: Point[Int]): Unit = {
    if (_size == size) {
      return
    }
    _size = size
    damageTransform
  }

  def size: Point[Int] = _size

  def center_=(center: Point[Int]): Unit = {
    _center = HVPoint(center.x , size.y - center.y)
    damageTransform
  }

  def center: Point[Int] = _center

  def resetCenter = _center = size / 2

  def worldCenter_=(center: Point[Double]): Unit = {
    if (_worldCenter == center) {
      return
    }
    _worldCenter = center
    damageTransform
  }

  def worldCenter: Point[Double] = _worldCenter

  def worldScale_=(scale: Double): Unit = {
    if (_worldScale == scale) {
      return
    }
    _worldScale = scale
    damageTransform
  }

  def worldScale: Double = _worldScale

  def damageTransform = {
    
  }
}



//object Hoge {
//  def main(args: Array[String]): Unit = {
//    val viewport = new Viewport
//    viewport.size = HVPoint(640, 480)
//    println(viewport.size)
//    viewport.resetCenter
//    println(viewport.center)
//    viewport.worldScale = 2.0
//    println(viewport.worldScale)
//
//  }
//}