// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require camaleon_cms/bootstrap.min.js


//Tamaño maximo de los archivos a subir. 
var maxFileSize = 10;
errorMessage = 'Los archivos exceden los ' + maxFileSize + 'MB maximos permitidos.';

$(document).on("change", ".file_tag", function (data) {
  var FileSize = data.target.files[0].size / 1024 / 1024; // in MB
  if (FileSize > maxFileSize) {
    alert(errorMessage);
    data.target.value = '';
  }
});

$(document).ready(function () {
  $("#submit_button").click(function (e) {
    var totalFileSize = 0
    $("#my-form").find("input[type=file]").each(function (index, field) {
      for (var i = 0; i < field.files.length; i++) {
        var file = field.files[i];
        var FileSize = file.size / 1024 / 1024; // in MB
        totalFileSize += FileSize;
        if (FileSize > maxFileSize) {
          alert(errorMessage);
          e.preventDefault();
        }
      }
    });
    if (totalFileSize > maxFileSize) {
      alert(errorMessage);
      e.preventDefault();
    }

    //Para aceptar los terminos y condiciones (Esto pasa cuando se utiliza jQuery)
    isTermsAccept = $("#terms").is(':checked')
    if (!isTermsAccept) {
      alert("Se deben aceptar los terminos y condiciones.");
      e.preventDefault();
    }

  });
});

//-------------------------------
function contrast() {
  $('html *:not(script, style, noscript)').each(function () {
    $(this).css("background", "none");
    $(this).css("background-color", "black");
    $(this).css("color", "white");
    $(this).css("box-shadow", "none");
    $(this).css("text-shadow", "none");
    $(this).css("text-color", "white");
  });
}

function reestablishText() {
  document.body.style.fontSize = "1em";
}

function reduceText() {
  reestablishText();
  document.body.style.fontSize = "0.75em";
}

function increaseText() {
  reestablishText();
  document.body.style.fontSize = "1.35em";
}
