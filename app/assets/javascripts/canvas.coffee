$ ->
  # Initialize canvas with template.
  window.canvas = new fabric.Canvas('canvas')
  
  fabric.Image.fromURL '/images/template.png', (img) ->
    canvas.add(img)
    img.set('evented', false)

  # Pick image on button click.
  $('#upload').on 'click', (event) ->
    event.preventDefault()

    $('#image-picker').click()

  # Place uploaded image on canvas.
  $('#image-picker').on 'change', (e) ->
    reader = new FileReader()
    reader.onload = (event) ->
      addFromUrl(event.target.result)
    reader.readAsDataURL(e.target.files[0])

  # Setup image slider
  $('#slider').slider(
    slide: (event, ui) ->
      minScale = window.scale
      range = minScale * 5 - minScale
      window.userImg.scale((ui.value / 100) * range + minScale)
      window.userImg.applyFilters(canvas.renderAll.bind(canvas))
  )

  # Take webcam image on click
  $('#take-webcam').on 'click', ->
    $('div.canvas-container').hide()
    $('div.select-image').hide()
    $('p.step-one').hide()

    $('div.select-webcam').show()
    $('p.webcam').show()
    $('#webcam').show()
    Webcam.attach('#webcam')

  $('#take-picture').on 'click', ->
    Webcam.snap (url) ->
      $('div.canvas-container').show()
      $('#webcam').remove()
      addFromUrl(url)

  # Hide initial things
  $('#slider').hide()
  $('div.looks-good').hide()
  $('p.step-two').hide()
  $('#webcam').hide()
  $('div.select-webcam').hide()
  $('p.webcam').hide()

addFromUrl = (url) ->
  fabric.Image.fromURL url, (img) ->
    window.userImg = img

    # Make image grayscale
    img.filters.push(new fabric.Image.filters.Grayscale())
    img.applyFilters(canvas.renderAll.bind(canvas))

    # Scale image to 500px
    window.scale = 500 / img.getBoundingRect().width
    img.scale(scale)

    # Hide the grab handles
    img.setControlsVisibility(
      bl: false
      br: false
      mb: false
      ml: false
      mr: false
      mt: false
      tl: false
      tr: false
      mtr: false
    )

    # Add to the canvas
    canvas.add(img)
    canvas.sendToBack(img)

    # Change steps
    $('#slider').show()
    $('div.looks-good').show()
    $('p.step-two').show()

    $('div.select-image').hide()
    $('p.step-one').hide()
    $('#webcam').hide()
    $('div.select-webcam').hide()
    $('p.webcam').hide()