$ ->
  # Initialize canvas with template.
  window.canvas = new fabric.Canvas('canvas')
  
  fabric.Image.fromURL '/images/template.png', (img) ->
    img.scale(0.25)
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
      fabric.Image.fromURL event.target.result, (img) ->
        window.userImg.remove() if window.userImg
        window.userImg = img

        # Make image grayscale
        img.filters.push(new fabric.Image.filters.Grayscale())
        img.applyFilters(canvas.renderAll.bind(canvas))

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

        # Scale image to 500px
        window.scale = 500 / img.getBoundingRect().width
        img.scale(scale)

        # Add to the canvas
        canvas.add(img)
        canvas.sendToBack(img)
    reader.readAsDataURL(e.target.files[0])