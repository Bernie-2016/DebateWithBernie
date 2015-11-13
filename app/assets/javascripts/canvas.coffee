$ ->
  # Initialize canvas with template.
  canvas = new fabric.Canvas('canvas')
  
  fabric.Image.fromURL '/images/template.png', (img) ->
    img.scale(0.25)
    canvas.add(img)
    img.set('evented', false)