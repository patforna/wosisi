whereispat.map = function() {
	
  	var ROUTE_START_DATE = "2012-04-01 00:00:00 +0000"
	
    var SHOW_TWEETS_AT_ZOOM = 3;	
    var START_MARKER = new google.maps.MarkerImage('/images/green_marker.png', null, null, null, null);
    var CURRENT_MARKER = new google.maps.MarkerImage('/images/red_marker.png', null, null, null, null);
    var TWITTER_MARKER = new google.maps.MarkerImage('/images/twitter_marker.png', null, null, null, null);

    var instance = {};	
    var map = createMap();
    var markers = [];
    var infoWindow = new google.maps.InfoWindow();

    instance.render = function(route, tweetedRoute) {
        showStartLocation(tweetedRoute);
        showCurrentLocation();
        showTweets(tweetedRoute);
        showApproximateRoute(tweetedRoute);
        fitBounds(tweetedRoute);
    };

    function createMap() {
        var map = new google.maps.Map($('#map_canvas')[0], { center: currentLocation(), zoom: 7, mapTypeId: google.maps.MapTypeId.TERRAIN });
        google.maps.event.addListener(map, 'zoom_changed', function() {
    		  var zoomLevel = map.getZoom();
          var showMarkers = zoomLevel >= SHOW_TWEETS_AT_ZOOM;
          $.each(markers, function() {
  	        this.setVisible(showMarkers);
  	      });
        });
        return map;
    };

    function currentLocation() {
        return new google.maps.LatLng($('.latitude').text(), $('.longitude').text());
    };

    function showStartLocation(tweetedRoute) {
      var start = tweetedRoute.places[0];
      new google.maps.Marker({
          position: new google.maps.LatLng(start.latitude, start.longitude),
          map: map,
          icon: START_MARKER,
          zIndex: 5
      });
    };

    function showCurrentLocation() {
        new google.maps.Marker({
            position: currentLocation(),
            map: map,
            animation: google.maps.Animation.BOUNCE,
            icon: CURRENT_MARKER
        });
    };

    function showTweets(tweetedRoute) {
        $.each(tweetedRoute.places, function() {
            var marker = new google.maps.Marker({
                position: new google.maps.LatLng(this.latitude, this.longitude),
                map: map,
                zIndex: 2,
                icon: TWITTER_MARKER,
                visible: false
            });
            markers.push(marker);

            var tweet = this.tweet;

            google.maps.event.addListener(marker, 'click', function() {
	            infoWindow.setContent(tweet);
    			    infoWindow.open(map, marker);
      			});			
        });
    };

    function showApproximateRoute(tweetedRoute) {
        var probableRoute = [];
        $.each(tweetedRoute.places, function() {
            if (Date.parse(this.visited_at) >= Date.parse(ROUTE_START_DATE)) {
              probableRoute.push(new google.maps.LatLng(this.latitude, this.longitude));
            }
        });

        new google.maps.Polyline({
            map: map,
            path: probableRoute,
            strokeColor: "#257890",
            strokeOpacity: 0.8,
            strokeWeight: 5,
            geodesic: true
        });
    };

    function fitBounds(tweetedRoute) {
        var bounds = new google.maps.LatLngBounds();
        $.each(tweetedRoute.places, function() { bounds.extend(new google.maps.LatLng(this.latitude, this.longitude)); });
        map.fitBounds(bounds);
    };

    return instance;
};