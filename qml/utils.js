.pragma library

function request(url, callback) {
    var xhr = new XMLHttpRequest()
    xhr.open('GET', url)
    xhr.onreadystatechange = function (event) {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status < 200 || xhr.status > 400) {
                return callback(new Error('Request failed'))
            }

            try {
                callback(null, JSON.parse(xhr.responseText))
            } catch (err) {
                callback(err)
            }
        }
    }
    xhr.onerror = function (err) {
        console.error(err)
        callback(err)
    }
    xhr.send()
}

function findCity(text, callback) {
    var url = 'https://autocomplete.travelpayouts.com/places2?term=' + text + '&locale=en'
    request(url, function(err, res) {
        if (err) {
            return callback(err)
        }

        if (res.error) {
            return callback(new Error(res.error))
        }

        var cities = res.map(function(airport) {
            return {
                name: airport.name,
                code: airport.code
            }
        })
        callback(null, cities)
    })
}

function formatDate(date) {
    if (!date) {
        return ''
    }

    var month = '' + (date.getMonth() + 1)
    var day = '' + date.getDate()
    var year = date.getFullYear()

    if (month.length < 2) {
        month = '0' + month
    }
    if (day.length < 2) {
        day = '0' + day
    }

    return [year, month, day].join('-')
}

function getSearchUrl(options) {
    var depart = formatDate(options.departDate)
    var ret = formatDate(options.returnDate)

    var url = 'https://' + options.baseUrl +'/flights/?' +
        'origin_iata=' + options.from +
        '&destination_iata=' + options.to +
        '&depart_date=' + depart +
        '&return_date=' + ret +
        '&one_way=' + (ret ? 'false' : 'true') +
        '&adults=' + (options.adults || 0) +
        '&children=' + (options.children || 0) +
        '&infants=' + (options.infants || 0) +
        '&currency=' + options.currency +
        '&with_request=true'

    return url
}

/**
 *
 * @param {string} color1 - hex color
 * @param {string} color2 - hex color
 * @returns {boolean} - true if color1 is darker than color2, false otherwise
 */
function isDarker(color1, color2) {
    return __getColorDarkness(color1.toString()) < __getColorDarkness(color2.toString())
  
    function __getColorDarkness(color) {
      return parseInt(color.slice(1, 3), 16) +
        parseInt(color.slice(3, 5), 16) +
        parseInt(color.slice(5), 16)
    }
  }
