$ ->
  $("#dropzone").click ->
    $("input#file").click()

  $('.upload_to_box').fileupload
    dropZone: $("#dropzone")
    disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator && navigator.userAgent)

  $(document).on "drop dragover", (e) ->
    e.preventDefault()
