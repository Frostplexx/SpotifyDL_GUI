const fs = require('fs');
const app  = require('electron')

process.env.SPOTIPY_CLIENT_SECRET = readSettings("clientsecret"); 
process.env.SPOTIPY_CLIENT_ID = readSettings("clientid"); 


let tabsWithContent = (function () {
    let tabs = document.querySelectorAll('.tabs li') ;
    let tabsContent = document.querySelectorAll('.tabcontent');
  
    let deactvateAllTabs = function () {
      tabs.forEach(function (tab) {
        tab.classList.remove('is-active');
      });
    };
  
    let hideTabsContent = function () {
      tabsContent.forEach(function (tabContent) {
        tabContent.classList.remove('is-active');
      });
    };
  
    let activateTabsContent = function (tab) {
      tabsContent[getIndex(tab)].classList.add('is-active');
    };
  
    let getIndex = function (el) {
      return [...el.parentElement.children].indexOf(el);
    };
  
    tabs.forEach(function (tab) {
      tab.addEventListener('click', function () {
        deactvateAllTabs();
        hideTabsContent();
        tab.classList.add('is-active');
        activateTabsContent(tab);
      });
    })
  
    tabs[0].click();
  })();



function menuswitch(id, parent){
  let settings = document.querySelectorAll(".settingsContent"); 
  settings.forEach(function (setting){
    setting.classList.remove("is-active"); 
  });
  let menuitems = document.querySelectorAll(".menu-list a"); 
  menuitems.forEach(function (menuitem){
    menuitem.classList.remove("is-active"); 
  });
  parent.classList.add("is-active");
  document.getElementById(id).classList.add("is-active");
}



//spotify_dl -l https://open.spotify.com/playlist/67JwlxPSFU2Qhx48xUFPLY -o C:\Users\danie\Music
//"spotify_dl -l " + val +" -o C:\\Users\\danie\\Music"
let outtext = document.getElementById("outtext"); 
let button = document.getElementById('downloadBtn');



function download(){
  const url = document.querySelector('#urlfield').value;
  const dir = document.querySelector('#dirfield').value;

  // outtext.textContent = " "; 
  console.log(url);
  button.classList.add("is-loading")


      var spawn = require('child_process').spawn,
      sp = spawn("spotify_dl", ["-l",url, "-o", dir]);
      console.log(sp)
  
      sp.stdout.on('data', function (data) {
        console.log('stdout: ' + data.toString());
        outtext.textContent += data.toString() + "\n";
      });
  
      sp.stderr.on('data', function (data) {
        console.log('stderr: ' + data.toString());
        outtext.textContent += data.toString() + "\n";
      });
  
      sp.on('exit', function (code) {
        var excode = code.toString();
        console.log('child process exited with code ' + excode);
        button.classList.remove("is-loading");
        switch (parseInt(excode)) {
          case 1:
            console.log("Finished with error!");
            outtext.textContent += "Finished with errorcode: " + excode
            break;
          
          case 0: 
            console.log("No Errors");
            outtext.textContent += "Finished!"
            break;
          default:
            console.log(excode);
            break;
        }
      });

      sp.on('error', function(err) {
        console.log('Oh nyo?!?! You caused an ewwow!!11 pwease stop *looks at you* ' + err);
        outtext.textContent += err;
        button.classList.remove("is-loading");
        errorselfcheck();
      });
  }




function clsmsg(){
  outtext.textContent = " "; 
}



//browse button functionality
async function browse(){
  const dialog = require('electron').remote.dialog;
  let filepath = await dialog.showOpenDialog({properties: ['openDirectory']})
  let dir = document.querySelector('#dirfield')
  dir.value = filepath.filePaths[0]; 
  stateHandle();
}

//enable/disable download button
{
  let url = document.querySelector('#urlfield');
  let dir = document.querySelector('#dirfield');
  let downbtn = document.querySelector("#downloadBtn");
  url.addEventListener("change", stateHandle);
  dir.addEventListener("change", stateHandle);
  
  downbtn.disabled = true; //setting button state to disabled
  function stateHandle() {
    if (dir.value === "" || url.value === "") {
      downbtn.disabled = true; //button remains disabled
    } else {
      downbtn.disabled = false; //button is enabled
    }
}


}


function errorselfcheck(){
  
  let spawn = require('child_process').spawn; 

  let py = spawn("python", ["-h"]);
  py.stdout.on('data', function () {
    console.log("python ok!");  


    let spt = spawn("spotify_dl", ["-h"]);
    spt.stdout.on('data', function () {
      console.log("spotify_dl ok!");
    });
    spt.on('error', function() {
      console.log("spotify_dl not installed!");
      outtext.textContent += "\n spotify_dl not found! Installing...";
      sleep(300); 


      let spin = spawn("pip", ["install", "spotify_dl"]);
      spin.stdout.on('data', function (out) {
        console.log(out);
        outtext.textContent += "\n" + out;
      });
      spin.on('error', function() {
        console.log('error installing spotify_dl!');
        outtext.textContent += "\nerror installing spotify_dl!";
        button.classList.remove("is-loading");
      });

      outtext.textContent += "\n trying to redownload your songs";
      sleep(300); 
      download();
      button.classList.remove("is-loading");
  
    });
  
    let pip = spawn("pip", ["help"]);
    pip.stdout.on('data', function () {
      console.log("pip ok!");
    });
    
    pip.on('error', function() {
      console.log("pip not installed!");
      outtext.textContent += "\npip could not be found!";
      button.classList.remove("is-loading");
    });

  });
  py.on('error', function() {
    console.log('python is not installed!');
    outtext.textContent += "\nPython is not installed!";
    button.classList.remove("is-loading");
  });

  py.stderr.on('data', function (data) {
    console.log('stderr: ' + data.toString());
    console.log("\nPython is not installed!")
    outtext.textContent += "\n" + data.toString() + "\n";
    outtext.textContent += "Don't download it from the Microsoft store, but from the official Website. Othewise it wont work!"
  });
}



//Spotify API key checks and stuff
{
  if(process.env.SPOTIPY_CLIENT_ID == "" || process.env.SPOTIPY_CLIENT_SECRET == ""){
    const msg = document.querySelector('#msg');
    console.log("no ID and Secret")
    msg.classList.add('is-active');
  } else {
    console.log("id and scecret found!")
  }

  let clientid = document.getElementById("clientid"); 
  let clientsecret = document.getElementById("clientsecret");

  if(clientid.value === "" && clientsecret.value === ""){
    clientid.value = readSettings("clientid"); 
    clientsecret.value = readSettings("clientsecret");
  } else {
    writeSettings("clientid", clientid.value); 
    writeSettings("clientsecret", clientsecret.value)
  }

  clientid.addEventListener("change", update);
  clientsecret.addEventListener("change", update);

  function update(){
    writeSettings("clientid", clientid.value.replace(/\s/g, '')); 
    writeSettings("clientsecret", clientsecret.value.replace(/\s/g, ''))

    process.env.SPOTIPY_CLIENT_SECRET = clientsecret.value.replace(/\s/g, ''); 
    process.env.SPOTIPY_CLIENT_ID = clientid.value.replace(/\s/g, '');

    if(process.env.SPOTIPY_CLIENT_ID == undefined || process.env.SPOTIPY_CLIENT_SECRET == undefined){
      const msg = document.querySelector('#msg');
      console.log("no ID and Secret")
      msg.classList.add('is-active');
    } else {
      console.log("id and scecret found!")
      msg.classList.remove('is-active');
    }

  }
}

//helperfunctions

function sleep(milliseconds) {
  const date = Date.now();
  let currentDate = null;
  do {
    currentDate = Date.now();
  } while (currentDate - date < milliseconds);
}



var path = require('path');
var settingsPath  = path.join(__dirname, "settings.json").toString(); 

console.log(settingsPath);

function readSettings(setting){
  let rawdata = fs.readFileSync(__dirname + "\\settings.json");
  let settings = JSON.parse(rawdata);
  return settings[setting];
}

function writeSettings(name, value){
  const fileName = settingsPath;
  const file = require(fileName);     
  file[name] = value;
  fs.writeFileSync(fileName, JSON.stringify(file, null, 2)); 
}