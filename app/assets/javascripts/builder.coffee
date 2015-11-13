window.Builder = React.createClass
  getInitialState: ->
    {
      step: 'CHOOSE_METHOD'
    }

  componentDidMount: ->
    # Initialize canvas with template.
    canvas = new fabric.Canvas('canvas')
    
    fabric.Image.fromURL '/images/template.png', (img) ->
      canvas.add(img)
      img.set('evented', false)

    $('#slider').slider
      slide: (event, ui) =>
        minScale = @state.scale
        range = minScale * 5 - minScale
        @state.image.scale((ui.value / 100) * range + minScale)
        @state.image.applyFilters(@state.canvas.renderAll.bind(@state.canvas))

    @setState(canvas: canvas)

  componentDidUpdate: ->
    if @state.step == 'TAKE_WEBCAM'
      Webcam.set(width: 500, height: 375)
      Webcam.setSWFLocation('/flash/webcam.swf')
      Webcam.attach('#webcam')

  addFromUrl: (url) ->
    fabric.Image.fromURL url, (img) =>
      # Make image grayscale
      img.filters.push(new fabric.Image.filters.Grayscale())
      img.applyFilters(@state.canvas.renderAll.bind(@state.canvas))

      # Scale image to 500px
      scale = 500 / img.getBoundingRect().width
      img.scale(scale)

      # Hide the grab handles
      img.setControlsVisibility(bl: false, br: false, mb: false, ml: false, mr: false, mt: false, tl: false, tr: false, mtr: false)

      # Add to the canvas
      @state.canvas.add(img)
      @state.canvas.sendToBack(img)

      @setState(
        image: img
        scale: scale
        step: 'DRAG_ZOOM'
      )

  importUpload: (event) ->
    event.preventDefault()
    $(@getDOMNode()).find('#image-picker').click()

  importWebcam: (event) ->
    event.preventDefault()
    @setState(step: 'TAKE_WEBCAM')

  processUpload: (event) ->
    reader = new FileReader()
    reader.onload = (event) =>
      @addFromUrl(event.target.result)
    reader.readAsDataURL(event.target.files[0])

  processWebcam: (event) ->
    event.preventDefault()
    Webcam.snap (url) =>
      @addFromUrl(url)
      Webcam.reset()

  backToImport: (event) ->
    event.preventDefault()
    @state.image.remove()
    @setState(step: 'CHOOSE_METHOD')

  render: ->
    directions = switch @state.step
      when 'CHOOSE_METHOD' then <p>First, select your image!</p>
      when 'DRAG_ZOOM' then <p>Next, drag and zoom to fit!</p>
      when 'TAKE_WEBCAM' then <p>Snap that selfie!</p>

    buttons = switch @state.step
      when 'CHOOSE_METHOD'
        <div>
          <a href='#' className={'btn'} onClick={@importUpload}>Upload Image</a>
          <a href='#' className={'btn'} onClick={@importWebcam}>Take With Webcam</a>
          <a href='#' className={'btn'} onClick={@importFacebook}>Import From Facebook</a>
          <input type='file' id='image-picker' className={'hidden'} onChange={@processUpload} />
        </div>
      when 'DRAG_ZOOM'
        <div>
          <a href='#' className={'btn'} onClick={@backToImport}>Use Different Image</a>
          <a href='#' className={'btn'}>Looks Good</a>
        </div>
      when 'TAKE_WEBCAM' then <a href='#' className={'btn'} onClick={@processWebcam}>Take Picture</a>

    return (
      <div>
        <div id='webcam' className={'hidden' unless @state.step == 'TAKE_WEBCAM'}></div>
        <div className={'hidden' if @state.step == 'TAKE_WEBCAM'}>
          <canvas id='canvas' width='500' height='500'></canvas>
        </div>
        <div className={"slider-wrapper #{'hidden' unless @state.step == 'DRAG_ZOOM'}"}>
          <div id='slider'></div>
        </div>
        <div className={'directions'}>
          {directions}
        </div>
        {buttons}
      </div>
    )