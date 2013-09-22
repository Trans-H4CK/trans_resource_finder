$(document).ready(function() {
  // #todo change this to just be map area
  $('#map-container').addClass("loading");

  // Get the url #fragement.
  function get_hash(key) {
    var hashobject = {};
    if (location.href.indexOf('#') != -1) {
      hash = location.href.substr(location.href.indexOf('#')+1).split('&');
      for (var i = 0; i < hash.length; i++) {
        if (hash[i].indexOf('=') != -1) {
          var parts = hash[i].split('=');
          hashobject[parts[0]] = parts[1];
        }
      }
    }
    return key ? (hashobject[key] ? hashobject[key] : null) : hashobject;
  }

  // Set the url fragment in form of #key=value
  function set_hash(key, value) {
    var hash = get_hash();
    hash[key] = value
    var hashArray = new Array();
    for (var i in hash) {
      hashArray.push(i + '=' + hash[i])
    }
    window.location.hash = hashArray.join('&');
  }

  // Remove from the url fragment where key in #key=value
  function remove_hash(key) {
    var hash = get_hash();
    var hashArray = new Array();
    for (var i in hash) {
      if (i != key) {
        hashArray.push(i + '=' + hash[i]);
      }
    }
    window.location.hash = hashArray.join('&');
  }

  var map = L.map('map', {
      scrollWheelZoom: false
  });
  L.tileLayer('http://{s}.tile.cloudmade.com/c01de5b85a184db09d54b984c0a65a6e/997/256/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
        maxZoom: 18,
  }).addTo(map);
  map.fitWorld();

  // Keep track of each marker.
  var markerArray =  new Array();

  // Global variable that is passed around to prevent refresh from resizing.
  var do_not_refresh = false;
  // Trigger json change on changing map.
  $(map).bind('moveend', function(event) {
    if (!do_not_refresh) {
      get_json({}, false);
    }
    else {
      do_not_refresh = false;
    }
  });
  // Bind on chage to category to update json.
  var $category = $('[name=category]');
  if (category = get_hash('category')) {
    $category.val(category);
  }

  // Might as well refresh on category change.
  $category.change(function() {
    get_json({}, true);
  });

  // On clicking go, search by zipcode and/or category.
  var $zipcode = $('[name=zip]');
  var $form = $('#locate');
  $form.submit(function(e) {
    // We only want zipcode to matter on first changing it
    data = {};
    if ($zipcode.val() && !data.zipcode) {
      data.zip_code = $zipcode.val();
      set_hash('zip_code', data.zip_code);
    }
    else {
      remove_hash('zip_code');
    }
    remove_hash('lat');
    remove_hash('lng');
    get_json(data, true);
    e.preventDefault();
  });


  // If zip code in url, set that and refresh json.
  zoom = get_hash('zoom') || 13
  if (zipcode = get_hash('zip_code')) {
    $zipcode.val(zipcode);
    get_json({zip_code : zipcode}, true);
  }
  // If lat long, set and refresh.
  else if((lat = get_hash('lat')) && (lng = get_hash('lng'))) {
    map.setView([lat, lng], zoom);
  }
  // Locate the user's current position as fallback if possible.
  else {
    map.locate({setView: true, maxZoom: zoom});
    $(map).bind('locationerror', function() {
      map.setView([37.761064, -122.417298], zoom);
    });
  }

  // Primary function that gts the json and renders the markers and list.
  function get_json(data, resize) {
    $('#map-container').addClass("loading");
    if (!data) {
      data = {};
    }

    // If no zipcode, set lat/lng to map center.
    if (!data.zip_code && !data.lat) {
      var center = map.getCenter();
      data.lat = center.lat;
      data.lon = center.lng;
      remove_hash('zip_code');
      set_hash('lat', data.lat);
      set_hash('lng', data.lon);
      set_hash('zoom', map.getZoom());
    }

    // Set category to currently selected.
    if (!data.category) {
      if ($category.val()) {
        data.category = $category.val();
        set_hash('category', data.category);
      }
      else {
        remove_hash('category');
      }
    }

    // Get distance (meters) from center to right bottom.
    if (data.lat && !data.distance) {
      var center = map.getCenter();
      data.distance = center.distanceTo(map.getBounds().getSouthWest());
    }

    // Set the page
    if (!data.page) {
      if (page = get_hash('page')) {
        data.page = page;
      }
    }
    else {
      set_hash('page', data.page);
    }
    $.ajax({
      url: "/api/v1/resources",
      data: data,
      accepts: {
        json: "application/vnd.trans_resource.v1"
      },
      success: function(data) {
        // Remove all current makers before adding new.
        if (markerArray.length) {
          while(marker = markerArray.pop()){
            map.removeLayer(marker);
          }
        }

        // Add new resources to map.
        if (data && data.resources) {
          L.geoJson(data.resources, {
            onEachFeature: onEachFeature
          }).addTo(map);

          // Resize current map to fit all markers.
          if (resize) {
            do_not_refresh = true;
            map.fitBounds(L.featureGroup(markerArray).getBounds());
          }

          // Add list of resources.
          $('#locations').html('');
          $.each(data.resources, function(key, location) {
            if (location_themed = theme_resource(location)) {
              $('#locations').append(location_themed);
            }
          });
          $('#pager').html('');
          if (data.total_entries > data.per_page) {
            output = '';
            if (data.page != 1) {
              output += '<a href=#" class="previous">Previous</a> ';
            }
            if (data.total_entries > data.per_page * (data.page - 1)) {
              output += '<a href="#" class="next">Next</a>';
            }
            $('#pager').html(output);
            $('#pager a.next').click(function(e) {
              get_json({page: (data.page + 1)});
              e.preventDefault();
            });
            $('#pager a.previous').click(function(e) {
              get_json({page: (data.page - 1)});
              e.preventDefault();
            });

          }
          $('#map-container').removeClass("loading");
        }
      },
      dataType: 'json',
      error: function() {
        $('#map-container').removeClass("loading");
        alert('Unable to fetch data. Sorry =(');
      }
    });

    // Theme how resource looks for location.
    function theme_resource(location) {
      var props = location.properties;
      var output =  '<article class="resource vcard">';
      if (props.website) {
        output  += '<h2 id="resource-' + props.id  + '" class="fn org"><a class="url" href="' + props.website + '">' + props.name + '</a></h2>';
      }
      else {
        output  += '<h2 id="resource-' + props.id  + '" class="fn org">' + props.name + '</h2>';
      }
      if (props.street_address_1 || props.street_address_2 || props.city || props.state ||props.zip) {
        output  += '<div class="resource-address adr">'
          + '<div class="label">Address</div>';
        if (props.street_address_1) {
          output += '<div class="resources-address-1 street-address">' + props.street_address_1 + (props.street_address_2 ? ', ' + props.street_address_2 : '') + '</div>';
        }
        output += '</div>';
        if (props.city || props.state ||props.zip) {
          var city_state_zip = '';
          if (props.city) {
            city_state_zip += (city_state_zip ? ', ' : '') + '<span class="locality">' + props.city + '</span>';
          }
          if (props.state) {
            city_state_zip += (city_state_zip ? ', ' : '') + '<span class="region">' + props.state + '</span>';
          }
          if (props.zip) {
            city_state_zip += (city_state_zip ? ', ' : '') + '<span class="postal-code">' + props.zip + '</span>';
          }
          output += '<div class="resource-address-city-state-zip">' + city_state_zip + "</div>";
        }
      }
      var titles = {
        'phone': {
          'label':'Phone',
          'class': 'tel'
        },
        'email': {
          'label':'Email',
          'class': 'email'
        },
        'contact_name': {
          'label':'Contact Name',
          'class': ''
        },
        'services_offered' : {
          'label':'Services Offered',
        },
        'notes' : {
          'label':'Notes',
          'class': 'note'
        },
        'distance': {
          'label':'Distance (mi)',
          'class': ''
        }
      }
      $.each(titles, function(key, options) {
        if (props[key]) {
          output  += '<div class="resource-' + key + ' ">'
            + '<span class="label">' + options.label + '</span>: '
            + '<span class="'  + (options.class ? options.class : '') + '">' + props[key] + '</span>'
            + '</div>';
        }
      });
      var ratings = {
        'accessibility_rating': 'Accessibility Rating',
        'trans_friendliness_rating': 'Trans* Friendliness Rating',
        'service_quality_rating': 'Service Quality Rating',
      }
      $.each(ratings, function(key, title) {
        if (props[key]) {
          output  += '<div class="resource-' + key + '">'
            + '<span class="label">' + title + '</span>: '
            + props[key] + '/5</div>';
        }
      });
      if (props.category) {
        output += '<div class="resource-category"><span class="label">Category</span>: <span class="category">'
          + props.category.name + '</span></div>';
      }
      output  += '<div class="resource-update"><a href="/resources/' + props.id + '/edit">Update</a></div>';
      output  +=  '</article>';
      return output;
    }

    function theme_resource_popup(location) {
      return '<a href="#resource-' + location.properties.id  + '">' + location.properties.name + '</a>';
    }

    function onEachFeature(feature, layer) {
      // does this feature have a property named popupContent?
      if (feature.properties && (location_popup = theme_resource_popup(feature))) {
        layer.bindPopup(location_popup);
      }
      addColorChange(feature, layer);
      // Keep track of the layer.
      markerArray.push(layer);
    }


    function addColorChange(feature, layer) {
      var url;
      var url_open;
      switch (feature.properties.category.name) {
        case "Healthcare":
          url = "assets/bathroom.png";
          url_open = "assets/pinkBathroom.png";
          break;
        case "Social":
          url = "assets/medical.png";
          break;
      }

      if (url) {
        layer.setIcon( L.icon({iconUrl:url, iconSize: [32, 32]}));
      }

      if (url && url_open) {
        layer.on('popupopen', function(e) {
          layer.setIcon( L.icon({iconUrl: url_open, iconSize: [32, 32]}));
        });

        layer.on('popupclose', function(e) {
          layer.setIcon( L.icon({iconUrl: url, iconSize: [32, 32]}));
        });
      }
    }
  }
});