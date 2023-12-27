document.addEventListener("DOMContentLoaded", function () {
  fetch("/listdir")
    .then((response) => response.json())
    .then((data) => {
      const fileList = document.getElementById("fileList");

      Object.keys(data).forEach((filename) => {
        const fileItem = document.createElement("div");
        fileItem.className = "file-update-container";
        fileItem.innerHTML = `
                    <input type="file" id="file-input-${filename}" style="display: none;">
                    <button class="file-button" onclick="processFileUpload('file-input-${filename}', '${filename}')">Update ${filename}</button>
                    `;
        fileList.appendChild(fileItem);
      });

      const fileItem = document.createElement("div");
      fileItem.className = "file-update-container";
      fileItem.innerHTML = `
                <input type="file" id="file-pack" style="display: none;" multiple="multiple">
                <button class = "file-button" onclick="processFileUpload('file-pack', 'pack' , true)">Upload Package</button>
                `;
      fileList.appendChild(fileItem);
    });
});

window.onload = function() {
  document.body.style.display = "flex"; // Change "block" to whatever display type you originally need, like "flex" or "grid"
};

function setpath() {
  var default_path = document.getElementById("newfile").files[0].name;
  document.getElementById("file-name").value = default_path;
}

/*Webserver has flat file structure, file name is the file path */
function processFileUpload(fileInputId, fileName, pack = false) {
  var fileInput = document.getElementById(fileInputId);
  var MAX_FILE_SIZE = 200 * 1024; // 200KB
  var MAX_FILE_SIZE_STR = "200KB";

  fileInput.click();
  fileInput.onchange = () => {
    const fileList = fileInput.files;

    if (fileList.length === 0) {
      alert("No file selected!");
      return;
    } else if (fileName.length === 0) {
      alert("File name on server is not set!");
      return;
    } else if (fileName.indexOf(" ") >= 0) {
      alert("File mame on server cannot have spaces!");
      return;
    } else if (!pack && fileName[fileName.length - 1] === "/") {
      alert("File name cannot end with '/'!");
      return;
    }

    document.getElementById(fileInputId).disabled = true;
    document
      .querySelectorAll(".upload-button")
      .forEach((btn) => (btn.disabled = true));

    uploadFile(0, fileList);
  };

  function uploadFile(fileIndex, fileList) {
    if (fileIndex < fileList.length) {
      var file = fileList[fileIndex];
      if (file.size > MAX_FILE_SIZE) {
        alert("File size must be less than " + MAX_FILE_SIZE_STR + "!");
        resetForm();
        return;
      }
      var xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4) {
          if (xhttp.status == 200) {
            console.log(xhttp.responseText);
            uploadFile(fileIndex + 1, fileList);
          } else {
            alert(xhttp.status + "Error!\n" + xhttp.responseText);
            resetForm();
          }
        }
      };
      var fileURL;
      if (pack) {
        fileURL = "/upload/" + file.name;
      } else {
        fileURL = "/upload/" + fileName;
      }
      xhttp.open("POST", fileURL, true);
      xhttp.send(file);
    } else {
      alert("File upload successful");
      resetForm();
    }
  }
  function resetForm() {
    document.getElementById(fileInputId).disabled = false;
    document.querySelectorAll(".upload-button").forEach(btn => btn.disabled = false);
  }
}
