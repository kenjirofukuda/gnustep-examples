const electron = require('electron')
// Module to control application life.
const app = electron.app
// Module to create native browser window.
const BrowserWindow = electron.BrowserWindow

const path = require('path')
const url = require('url')
const Menu = electron.Menu

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow

function createWindow () {
  // Create the browser window.
  mainWindow = new BrowserWindow(
      {width: 800, height: 600, webPreferences: { nodeIntegration: false }})

  // and load the index.html of the app.
  mainWindow.loadURL(url.format({
    pathname: path.join(__dirname, 'gdsfeel/dist/canvas.html'),
    protocol: 'file:',
    slashes: true
  }))

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null
  })
  installMyMenus();
}

function installMyMenus () {
  const MenuItem = electron.MenuItem
  const appMenu = Menu.getApplicationMenu();
  const dialog = electron.dialog
  const debugMenu = new MenuItem (
    {
      label: 'Debug',
      submenu: [
        {
          label: 'Open AppConfigPath',
          click: function (item, focusedWindow) {
            dialog.showMessageBox(mainWindow, {
              message: 'Hage'
            })
          }
        },
        {
          type: 'separator'
        },
        {
          label: 'Show Axis line',
          click: function (item, focusedWindow) {
            dialog.showMessageBox(mainWindow, {
              message: 'Show Axis line'
            })
          }
        },
        {
          label: 'Show Extent bounds',
          click: function (item, focusedWindow) {
            dialog.showMessageBox(mainWindow, {
              message: 'Show Extent bounds'
            })
          }
        },
      ]
    }
  )
  const viewMenu = new MenuItem (
    {
      label: 'View',
      submenu: [
        {
          label: 'Fit',
          click: function (item, focusedWindow) {
            dialog.showMessageBox(mainWindow, {
              message: 'Fit'
            })
          }
        }
      ]
    }
  )
  appMenu.append(debugMenu)
  appMenu.items.forEach ( function (menuItem) {
    if (menuItem.label === 'View') {
      menuItem.submenu.append(new MenuItem({type: 'separator'}))
      viewMenu.submenu.items.forEach (function (e) {
        menuItem.submenu.append(e)
      })
    }
  })
  Menu.setApplicationMenu(appMenu)
}


// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow)

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow()
  }
})

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
