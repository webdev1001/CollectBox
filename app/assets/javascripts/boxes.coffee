$ ->
  $('.upload_to_box').fileupload
    dropZone: $("#dropzone")
    disableImageResize: false
    progressInterval: 10
    singleFileUploads: false
    paramName: 'files[]'
    progressall: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10);
      $('#progress').css('width', progress + "%")


  $(document).on "drop dragover", (e) ->
    e.preventDefault()
