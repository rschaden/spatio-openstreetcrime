OsmHeatMap =
  map: null
  initialize: ->
    if @map isnt null
      return
    epsg4326 = new OpenLayers.Projection('EPSG:4326')
    epsg900913 = new OpenLayers.Projection('EPSG:900913')
    @map = new OpenLayers.Map('heat_map')
    @layer = new OpenLayers.Layer.OSM()

    @crime_data =
      max: 1,
      data: []
    for report in ReportReceiver.reports
      if report.location.type == "Point"
        @crime_data.data.push
          count: 1
          lonlat: new OpenLayers.LonLat(report.location.coordinates[0], report.location.coordinates[1]).transform(epsg900913 ,epsg4326)

    @heatmap = new OpenLayers.Layer.Heatmap( "Heatmap Layer", @map, @layer, {visible: true, radius:8}, {isBaseLayer: false, opacity: 0.3, projection: new OpenLayers.Projection("EPSG:4326")});
    @map.addLayers [@layer, @heatmap]
    @map.setCenter(new OpenLayers.LonLat(13.5, 52.5).transform(epsg4326, epsg900913), 10)
    @heatmap.setDataSet @crime_data


MapStyle =
  renderer: ->
    renderer = OpenLayers.Util.getParameters(window.location.href).renderer
    renderer = (if (renderer) then [renderer] else OpenLayers.Layer.Vector::renderers)

  layer_style: ->
    layer_style = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style['default'])
    layer_style.fillOpacity = 0.3
    layer_style.graphicOpacity = 1
    layer_style

  style: (color) ->
    style = OpenLayers.Util.extend({}, @.layer_style())
    style.strokeColor = color
    style.fillColor = color
    style

