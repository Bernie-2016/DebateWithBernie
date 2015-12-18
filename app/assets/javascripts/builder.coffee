window.Builder = React.createClass
  getInitialState: ->
    {
      step: 'CHOOSE_METHOD'
      photos: []
    }

  componentDidMount: ->
    # Initialize canvas with template.
    canvas = new fabric.Canvas('canvas')
    canvas.selection = false
    
    fabric.Image.fromURL '/images/template.png', (img) ->
      canvas.add(img)
      img.set(evented: false)

    @setState(canvas: canvas)
    @addOutline()

    $('#slider').slider
      slide: (event, ui) =>
        minScale = @state.scale
        range = minScale * 5 - minScale
        @state.image.scale((ui.value / 100) * range + minScale)
        @state.image.applyFilters(@state.canvas.renderAll.bind(@state.canvas))

  componentDidUpdate: ->
    if @state.step is 'TAKE_WEBCAM'
      Webcam.set(width: 500, height: 375)
      Webcam.setSWFLocation('/flash/webcam.swf')
      Webcam.attach('#webcam')

  addOutline: ->
    fabric.Image.fromURL '/images/outline.png', (img) =>
      img.scale(0.8)
      img.set({left: 50, top: 75, evented: false})
      img.setControlsVisibility(bl: false, br: false, mb: false, ml: false, mr: false, mt: false, tl: false, tr: false, mtr: false)
      @state.canvas.add(img)
      @state.canvas.sendToBack(img)
      @setState(outline: img)

  addFromUrl: (url, exif = null) ->
    @state.outline.remove()

    fabric.Image.fromURL url, (img) =>
      # Make image grayscale
      img.filters.push(new fabric.Image.filters.Grayscale())
      img.applyFilters(@state.canvas.renderAll.bind(@state.canvas))

      # Scale image to 500px
      scale = 500 / img.getBoundingRect().width
      img.scale(scale)

      # Fix EXIF if necessary.
      if exif
        switch exif.Orientation
          when 8 then img.setAngle(270)
          when 3 then img.setAngle(180)
          when 6 then img.setAngle(90)

      # Hide the grab handles
      img.setControlsVisibility(bl: false, br: false, mb: false, ml: false, mr: false, mt: false, tl: false, tr: false, mtr: false)

      # Add to the canvas
      @state.canvas.add(img)
      @state.canvas.sendToBack(img)

      @setState(
        outline: null
        image: img
        scale: scale
        step: 'DRAG_ZOOM'
      )
    , { crossOrigin: true }

  importUpload: (event) ->
    event.preventDefault()
    $(@getDOMNode()).find('#image-picker').click()

  importWebcam: (event) ->
    event.preventDefault()
    @setState(step: 'TAKE_WEBCAM')

  importFacebook: (event) ->
    event.preventDefault()
    FB.getLoginStatus (response) =>
      if response.status is 'connected'
        @processFacebook()
      else
        FB.login (response) =>
          if response.status is 'connected'
            @processFacebook()
          else
            alert 'You must allow Facebook access to import a photo.' 
        , { scope: 'email,user_photos' }

  processUpload: (event) ->
    file = event.target.files[0]
    self = @
    EXIF.getData file, ->
      exif = @
      reader = new FileReader()
      reader.onload = (event) ->
        self.addFromUrl(event.target.result, exif.exifdata)
      reader.readAsDataURL(file)

  processWebcam: (event) ->
    event.preventDefault()
    Webcam.snap (url) =>
      @addFromUrl(url)
      Webcam.reset()

  processFacebook: ->
    FB.api '/me/albums', { fields: 'id,name,type' }, (response) =>
      profileAlbumId = null
      while profileAlbumId is null
        if response
          for album in response.data
            profileAlbumId = album.id if album.name is 'Profile Pictures' && album.type is 'profile'
          if profileAlbumId
            FB.api "/#{profileAlbumId}/photos", { fields: 'images' }, (r) =>
              @setState(step: 'CHOOSE_FACEBOOK', photos: r.data, next: r.paging.next)
          else
            $.getJSON response.paging.next, (r) -> 
              response = r
            response = null

  processMorePhotos: (event) ->
    event.preventDefault()
    if @state.next
      $.getJSON @state.next, (response) =>
        @setState(photos: response.data, next: response.paging.next)
    else
      alert "Facebook says there aren't any more photos!"

  processChooseFacebook: (event) ->
    id = $(event.target).data('id')
    photo = @state.photos.find (photo) ->
      photo.id is id.toString()
    @setState(step: 'IMPORTING_FACEBOOK')
    @addFromUrl(photo.images[0]['source'])

  backToImport: (event) ->
    event.preventDefault()
    @state.image.remove() if @state.image
    @addOutline() unless @state.outline
    @setState(step: 'CHOOSE_METHOD')

  done: (event) ->
    event.preventDefault()
    @setState(step: 'UPLOADING')
    $.post '/', { image: { file: @state.canvas.toDataURL() } }, (response) ->
      if response.error
        alert 'An error occurred; please try again.'
        @setState(step: 'DRAG_ZOOM')
      else
        window.location.href = "/images/#{response.id}"

  render: ->
    directions = switch @state.step
      when 'CHOOSE_METHOD' then <p>First, select your image!</p>
      when 'DRAG_ZOOM' then <p>Next, drag and zoom to fit!</p>
      when 'TAKE_WEBCAM' then <p>Snap that selfie!</p>
      when 'CHOOSE_FACEBOOK' then <p>Click an image to import it.</p>
      when 'IMPORTING_FACEBOOK' then <p>Importing from Facebook - just a moment.</p>
      when 'UPLOADING' then <p>Uploading your image! Sit tight, this may take a moment.</p>

    buttons = switch @state.step
      when 'CHOOSE_METHOD'
        <div>
          <a href='#' className={'btn'} onClick={@importUpload}>Upload <span className={'or-take'}>or Take an</span> Image</a>
          <a href='#' className={'btn btn-webcam'} onClick={@importWebcam}>Take With Webcam</a>
          <a href='#' className={'btn'} onClick={@importFacebook}>Import From Facebook</a>
          <input type='file' id='image-picker' className={'hidden'} onChange={@processUpload} />
        </div>
      when 'DRAG_ZOOM'
        <div>
          <a href='#' className={'btn'} onClick={@backToImport}>Use Different Image</a>
          <a href='#' className={'btn'} onClick={@done}>Looks Good</a>
        </div>
      when 'CHOOSE_FACEBOOK'
        <div>
          <a href='#' className={'btn'} onClick={@backToImport}>Back</a>
          <a href='#' className={'btn'} onClick={@processMorePhotos}>Load More Photos</a>
        </div>
      when 'TAKE_WEBCAM' then <a href='#' className={'btn'} onClick={@processWebcam}>Take Picture</a>

    return (
      <div>
        <div id='webcam' className={'hidden' unless @state.step is 'TAKE_WEBCAM'}></div>
        <div className={'hidden' if @state.step is 'TAKE_WEBCAM' || @state.step is 'CHOOSE_FACEBOOK'}>
          <canvas id='canvas' width='500' height='500'></canvas>
        </div>
        <div className={"gallery #{'hidden' unless @state.step is 'CHOOSE_FACEBOOK'}"}>
          {for photo in @state.photos
            <div className={'photo-wrapper'}>
              <img src={photo.images[photo.images.length - 1]['source']} data-id={photo.id} onClick={@processChooseFacebook} />
            </div>
          }
        </div>
        <div className={"slider-wrapper #{'hidden' unless @state.step is 'DRAG_ZOOM'}"}>
          <div id='slider'></div>
        </div>
        <div className={'directions'}>
          {directions}
        </div>
        {buttons}
      </div>
    )