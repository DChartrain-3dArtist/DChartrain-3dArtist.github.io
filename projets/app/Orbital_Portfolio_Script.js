document.getElementById("start-button").addEventListener("click", function() {
    document.getElementById("start-screen").style.display = "none";
    document.getElementById("custom-loading").style.display = "flex";
    
    var canvas = document.querySelector("#unity-canvas");
    var buildUrl = "/projets/projet_asset/Build";
    var loaderUrl = buildUrl + "/Export.loader.js";
    var config = {
        dataUrl: buildUrl + "/Export.data",
        frameworkUrl: buildUrl + "/Export.framework.js",
        codeUrl: buildUrl + "/Export.wasm",
        streamingAssetsUrl: "StreamingAssets",
        companyName: "DefaultCompany",
        productName: "WebAppProject",
        productVersion: "0.1.0",
    };
    
    if (/Mobi|Android/i.test(navigator.userAgent)) {
        canvas.requestFullscreen();
    }
    
    var script = document.createElement("script");
    script.src = loaderUrl;
    script.onload = () => {
        createUnityInstance(canvas, config, (progress) => {
            var progressPercentage = Math.round(progress * 100) + "%";
            document.querySelector(".progress-bar").style.width = progressPercentage;
            document.querySelector(".progress-text").textContent = progressPercentage;
        }).then(() => {
            document.getElementById("custom-loading").style.display = "none";
        }).catch((message) => {
            alert(message);
        });
    };
    document.body.appendChild(script);
});
