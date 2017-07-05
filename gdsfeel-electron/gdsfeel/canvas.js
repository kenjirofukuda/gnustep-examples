/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global GDS, GEO, createjs, Snap */
"use strict";

var gStructure = null;
var gStructureView = null;
var gQueue = null;
var gWaitMSecs = 10;

function loadIt() {
  $("#canvas-wrapper").css("display", "block");
  setupRuntimeBrowser();
  window.addEventListener("resize", function () {
    clearTimeout(gQueue);
    gQueue = setTimeout(function () {
      adjustPortSize();
    }, gWaitMSecs);
  }, false);

  adjustPortSize();
  gStructure = new GDS.Structure();
  var data = sampleData();
  data.nodes.forEach(function (node) {
    var p3 = node.position;
    var hash = {
      "vertices": [[p3[0], p3[2]]],
      "type": "point"
    };
    gStructure.addElement(new GDS.Point(hash));
  });


  gStructureView = new GDS.StructureView("canvas", gStructure);
  gStructureView.addMouseMoveListener(function (e) {
    $("#deviceX").html(sprintf("%5d", e.offsetX));
    $("#deviceY").html(sprintf("%5d", e.offsetY));
    var worldPoint = gStructureView.port.deviceToWorld(e.offsetX, e.offsetY);
    $("#worldX").html(sprintf("%+20.4f", worldPoint.x.roundDigits(4)));
    $("#worldY").html(sprintf("%+20.4f", worldPoint.y.roundDigits(4)));
  });

  gStructureView.fit();
}

function adjustPortSize() {
  // FIXME: use box.. flex...
  var topbarHeight = $("#topbar").css("display") === "none" ? 0 : $("#topbar").height();
  var statusbarHeight = $("#statusbar").height();
  var w = $("#canvas-wrapper").width();
  $("#canvas-wrapper").css("height", $("html").height() - (topbarHeight + statusbarHeight));
  var h = $("#canvas-wrapper").height();
  $("#canvas").attr("width", w);
  $("#canvas").attr("height", h);
  if (gStructureView) {
    gStructureView.port.setSize(w, h);
  }
  $("#canvas-wrapper").css("display", "block");

}

function msg(s) {
  var msgTag = $("#msg")[0];
  if (msgTag) {
    msgTag.innerHTML = s;
  }
  console.log(s);
}

function setTopbarVisible(visible) {
  if (visible) {
    $("#topbar").show();
  }
  else {
    $("#topbar").hide();
  }
  adjustPortSize();
}

function hideTopbar() {
  setTopbarVisible(false);
}


function inElectron() {
  // FIXME: adhook
  return navigator.userAgent.toLowerCase().indexOf("electron") > 0 ;
}


function setupRuntimeBrowser() {
  setTopbarVisible(! inElectron());
}
