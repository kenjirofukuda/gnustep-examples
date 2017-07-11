package gds.geometry

/**
  * Created by kenjiro on 2017/07/08.
  */

case class Point[T](x: T, y: T)(implicit num: Numeric[T]) {

  import Numeric.Implicits._

  def /(v: Double): Point[T] = new Point((x.toDouble / v).asInstanceOf[T], (y.toDouble / v).asInstanceOf[T])

  def rounded: Point[Int] = new Point[Int](Math.round(x.asInstanceOf[Float]), Math.round(y.asInstanceOf[Float]))

  def toDouble: Point[Double] = new Point[Double](x.toDouble, y.toDouble)

  def unary_- = new Point(-x, -y)
}


object HVPoint {
  def apply(x: Int, y: Int): Point[Int] = new Point[Int](x, y)
}

object XYPoint {
  def apply(x: Double, y: Double): Point[Double] = new Point[Double](x, y)
}

//case class XYPoint(x: Double, y: Double)


class Viewport {
  private var _size: Point[Int] = HVPoint(0, 0)
  private var _center: Point[Int] = HVPoint(0, 0)
  private var _worldCenter: Point[Double] = XYPoint(0, 0)
  private var _worldScale: Double = 0.0
  private var _basicTransform: MatrixTransform2x3 = null;

  def size_=(size: Point[Int]): Unit = {
    if (_size == size) {
      return
    }
    _size = size
    damageTransform
  }

  def size: Point[Int] = _size

  def center_=(center: Point[Int]): Unit = {
    _center = HVPoint(center.x, size.y - center.y)
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
    _basicTransform = null
  }

  def trasnform: MatrixTransform2x3 = basicTransform

  def basicTransform: MatrixTransform2x3 = {
    if (_basicTransform == null) {
      _basicTransform = lookupBasicTransform
    }
    _basicTransform
  }

  def lookupBasicTransform: MatrixTransform2x3 = {
    var m = new MatrixTransform2x3
    m.setScale(XYPoint(1.0, -1.0))
    m.offset = XYPoint(0, size.y)
    m = m.composedWithLocal(MatrixTransform2x3.withOffset(center.toDouble))
    m = m.composedWithLocal(MatrixTransform2x3.withScale(worldScale))
    m = m.composedWithLocal(MatrixTransform2x3.withOffset(-worldCenter))
    m
  }
}


// form Pharo
class MatrixTransform2x3 {
  val elements = new Array[Double](6)

  def a11: Double = elements(0)

  def a11_=(v: Double): Unit = elements(0) = v

  def a12: Double = elements(1)

  def a12_=(v: Double): Unit = elements(1) = v

  def a13: Double = elements(2)

  def a13_=(v: Double): Unit = elements(2) = v

  def a21: Double = elements(3)

  def a21_=(v: Double): Unit = elements(3) = v

  def a22: Double = elements(4)

  def a22_=(v: Double): Unit = elements(4) = v

  def a23: Double = elements(5)

  def a23_=(v: Double): Unit = elements(5) = v

  def offset_=(p: Point[Double]): Unit = {
    a13 = p.x
    a23 = p.y
  }

  def offset: Point[Double] = XYPoint(a13, a23)

  def setIdentity(): Unit = {
    a11 = 1.0
    a12 = 0.0
    a13 = 0.0
    a21 = 0.0
    a22 = 1.0
    a23 = 0.0
  }

  def setAngleRadians(radians: Double): Unit = {
    val s = Math.sin(radians)
    val c = Math.cos(radians)
    a11 = c
    a12 - s
    a21 = s
    a22 = c
  }

  def setAngleDegress(degress: Double): Unit = {
    setAngleRadians((Math.PI / 180.0) * degress)
  }


  def setScale(scale: Point[Double]): Unit = {
    a11 = scale.x
    a22 = scale.y
  }

  def setScale(scale: Double): Unit = {
    setScale(XYPoint(scale, scale))
  }

  def isPureTranslation: Boolean = a11 == 1.0 && a12 == 0.0 && a22 == 0.0 && a21 == 1.0

  def isIdentity: Boolean = isPureTranslation && a12 == 1.0 && a23 == 0.0


  def transformPoint(p: Point[Double]): Point[Double] = {
    XYPoint(p.x * a11 + (p.y * a12) + a13, p.x * a21 + (p.y * a22) + a23)
  }

  def invertPoint(p: Point[Double]): Point[Double] = {
    val x = p.x - a13
    val y = p.y - a23
    var det = a11 * a22 - (a12 * a21)
    if (det == 0.0) {
      return XYPoint(0, 0)
    }
    else {
      det = 1.0 / det
      val detX = (x * a22) - (a12 * y)
      val detY = a11 * y - (x * a21)
      return XYPoint(detX * det, detY * det)
    }
  }

  def localPointToGlobal(p: Point[Double]): Point[Int] = transformPoint(p).rounded

  def globalPointToLocal(p: Point[Int]): Point[Double] = invertPoint(XYPoint(p.x, p.y))

  def composedWithLocal(t: MatrixTransform2x3): MatrixTransform2x3 = {
    val result = new MatrixTransform2x3
    result.a11 = a11 * result.a11 + (a12 * result.a21)
    result.a12 = a11 * result.a12 + (a12 * result.a22)
    result.a13 = a13 + (a11 * result.a13) + (a12 * result.a23)
    result.a21 = a21 * result.a11 + (a22 * result.a21)
    result.a22 = a21 * result.a12 + (a22 * result.a22)
    result.a23 = a23 + (a21 * result.a13) + (a22 * result.a23)
    result
  }

}

object MatrixTransform2x3 {
  def identity: MatrixTransform2x3 = {
    val instance = new MatrixTransform2x3
    instance.setIdentity
    instance.setScale(1.0)
    instance
  }

  def withOffset(p: Point[Double]): MatrixTransform2x3 = {
    val instance = this.identity
    instance.offset = p
    instance
  }

  def withScale(s: Point[Double]): MatrixTransform2x3 = {
    val instance = this.identity
    instance.setScale(s)
    instance
  }

  def withScale(s: Double): MatrixTransform2x3 = withScale(XYPoint(s, s))

}


object Hoge {
  def not_main(args: Array[String]): Unit = {
    val viewport = new Viewport
    viewport.size = HVPoint(640, 480)
    println(viewport.size)
    viewport.resetCenter
    println(viewport.center)
    viewport.worldScale = 2.0
    println(viewport.worldScale)
  }
}