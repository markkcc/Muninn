//<script>
  function submitHiddenForm() {
    var url = document.getElementById("textInput").textContent;
    document.getElementById("scan_URL").value = url;
    document.getElementsByName('commit')[0].click();
    startLoading();
  }

  async function startLoading() {
    if (document.getElementById('textInput').textContent == "")
          return;
    document.getElementById('animlogo').beginElement();
    document.getElementById('searchBar').style.opacity = '0';
    document.getElementById('subButtons').style.opacity = '0';
    document.getElementById('footer').style.opacity = '0';
    await new Promise(resolve => setTimeout(resolve, 600));
    document.getElementById('footer').textContent = "";
    document.getElementById('searchBar').style.display = "none";
    document.getElementById('subButtons').style.display = "none";
    document.getElementById('footer').style.opacity = '1';
    await new Promise(resolve => setTimeout(resolve, 600));
    slowLoadFooter("[SCANNING]: ...........");
    await new Promise(resolve => setTimeout(resolve, 2200));
    randomLoaderFooter();
  };

  async function slowLoadFooter(inputstr) {
        document.getElementById('footer').textContent = "";
        charsArray = [...inputstr];
        for (i=0; i < charsArray.length; i++) {
            document.getElementById('footer').append(charsArray[i]);
            await new Promise(resolve => setTimeout(resolve, 69));
        }
  };

  async function randomLoaderFooter() {
    var msToWait = Math.floor((Math.random() * 4884) + 6969);
    for ( i=1001; i < msToWait; i+=69) {
      document.getElementById('footer').textContent = "[SCANNING]: " + i + " / " + msToWait;
      await new Promise(resolve => setTimeout(resolve, 69));
    }
    document.getElementById('footer').textContent = "[SCANNING]: COMPLETE!";
    document.getElementById('animlogo').endElement();
    await new Promise(resolve => setTimeout(resolve, 1600));
    slowLoadFooter("[DISENGAGING]");
    await new Promise(resolve => setTimeout(resolve, 4200));
    slowLoadFooter("[STANDBY]");
  }

  function toggleScreenshot() {
    var screenshotButton = document.getElementsByClassName("baffled")[0];

    if(screenshotButton.textContent == "[ENABLED]") {
      screenshotButton.textContent = "[DISABLED]";
      screenshotButton.style = "color: red";
    } else {
      screenshotButton.textContent = "[ENABLED]";
      screenshotButton.style = "color: lime";
    }

    document.getElementById("scan_screenshot_enabled").click();
  }

  function toggleVT() {
    var vtButton = document.getElementsByClassName("baffled")[1];

    if(vtButton.textContent == "[ENABLED]") {
      vtButton.textContent = "[DISABLED]";
      vtButton.style = "color: red";
    } else {
      vtButton.textContent = "[ENABLED]";
      vtButton.style = "color: lime";
    }

    document.getElementById("scan_virustotal_enabled").click();
  }

  function toggleWHOIS() {
    var whoisButton = document.getElementsByClassName("baffled")[2];

    if(whoisButton.textContent == "[ENABLED]") {
      whoisButton.textContent = "[DISABLED]";
      whoisButton.style = "color: red";
    } else {
      whoisButton.textContent = "[ENABLED]";
      whoisButton.style = "color: lime";
    }

    document.getElementById("scan_whois_enabled").click();
  }

  function enableAllonLoad() {
    document.getElementById("scan_screenshot_enabled").checked = true;
    document.getElementById("scan_virustotal_enabled").checked = true;
    document.getElementById("scan_whois_enabled").checked = true;

    console.log("Muninn Status: ARMED | STANDBY");

    var urlinputbox = document.getElementById("textInput");
    urlinputbox.addEventListener("keydown", function (e) {
    if (e.keyCode === 13) {  //checks whether the pressed key is "Enter"
        document.getElementById("search-button").click();
      }
    });
  }
