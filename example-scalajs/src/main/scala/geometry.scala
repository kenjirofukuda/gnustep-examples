package gds.geometry


/**
  * Created by kenjiro on 2017/07/08.
  */

class Point[T](x: T, y: T) (implicit num: Numeric[T]) {
  import Numeric.Implicits._
  def /(v: Double): Point[T] = new Point((x.toDouble / v).asInstanceOf[T], (y.toDouble / v).asInstanceOf[T])

}


case class HVPoint(x: Int, y: Int) {
  def /(v: Number):HVPoint = HVPoint((x / v.doubleValue).toInt, (y / v.doubleValue).toInt )
}

case class XYPoint(x: Double, y: Double)


class Viewport() {
  private var _size: HVPoint = HVPoint(0, 0)
  private var _center: HVPoint = HVPoint(0, 0)
  private var _worldCenter: XYPoint = XYPoint(0,0)
  private var _worldScale: Double = 0.0
  private var _hoge: Point[Int] = new Point[Int](10, 10)

  def size_=(size: HVPoint): Unit = {
    if (_size == size) {
      return
    }
    _size = size
    damageTransform
  }

  def size: HVPoint = _size

  def center_=(center: HVPoint): Unit = {
    _center = HVPoint(center.x , size.y - center.y)
    damageTransform
  }

  def center: HVPoint = _center

  def resetCenter = _center = size / 2



  def worldCenter_=(center: XYPoint): Unit = {
    if (_worldCenter == center) {
      return
    }
    _worldCenter = center
    damageTransform
  }

  def worldCenter: XYPoint = _worldCenter


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



object Hoge {
  def main(args: Array[String]): Unit = {
    val viewport = new Viewport
    viewport.size = HVPoint(640, 480)
    println(viewport.size)
    viewport.resetCenter
    println(viewport.center)
    viewport.worldScale = 2.0
    println(viewport.worldScale)
    
  }
}