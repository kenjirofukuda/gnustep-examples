/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global GEO */

var GDS = {};

// https://stackoverflow.com/questions/3944122/detect-left-mouse-button-press
GDS.detectLeftButton = function (evt) {
  evt = evt || window.event;
  if ("buttons" in evt) {
    return evt.buttons == 1;
  }
  var button = evt.which || evt.button;
  return button == 1;
}

GDS.detectMiddleButton = function (evt) {
  evt = evt || window.event;
  if ("buttons" in evt) {
    return evt.buttons == 4;
  }

  if ("button" in evt) {
    return evt.button == 1;
  }

  if ("which" in evt) {
    return evt.which == 2;
  }
  return false;
}
