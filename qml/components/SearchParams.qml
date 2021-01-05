import QtQuick 2.9
import Qt.labs.platform 1.0

Item {
    property string fromIata
    property string fromCity
    property string toIata
    property string toCity
    // null|Date
    property var departDate: new Date(Date.now() + 24 * 60 * 60 * 1000) // tomorrow
    // null|Date
    property var returnDate
    property int adultsNumber: 1
    property int childrenNumber: 0
    property int infantsNumber: 0
    property string currency: 'EUR'

    readonly property string settingsPath: StandardPaths.writableLocation(StandardPaths.AppConfigLocation) + '/search-params.json'

    Component.onCompleted: {
        read()

        departDateChanged.connect(save)
        returnDateChanged.connect(save)
        adultsNumberChanged.connect(save)
        childrenNumberChanged.connect(save)
        infantsNumberChanged.connect(save)
        currencyChanged.connect(save)
    }

    function setFrom(iata, name) {
        fromIata = iata
        fromCity = name
        save()
    }

    function setTo(iata, name) {
        toIata = iata
        toCity = name
        save()
    }

    function save() {
        var request = new XMLHttpRequest();
        request.open("PUT", settingsPath)

        request.send(JSON.stringify({
            fromIata: fromIata,
            fromCity: fromCity,
            toIata: toIata,
            toCity: toCity,
            departDate: departDate ? departDate.getTime(): undefined,
            returnDate: returnDate ? returnDate.getTime(): undefined,
            adultsNumber: adultsNumber || 0,
            childrenNumber: childrenNumber || 0,
            infantsNumber: infantsNumber || 0,
            currency: currency
        }));
    }

    function read() {
        var request = new XMLHttpRequest();
        request.open("GET", settingsPath);
        request.onreadystatechange = function(event) {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (!request.responseText) {
                    return
                }

                try {
                    var preferences = JSON.parse(request.responseText)
                    fromIata = preferences.fromIata
                    fromCity = preferences.fromCity
                    toIata = preferences.toIata
                    toCity = preferences.toCity

                    if (new Date(preferences.departDate) > departDate) {
                        departDate = new Date(preferences.departDate)
                    }

                    if (preferences.returnDate && new Date(preferences.returnDate) > departDate) {
                        returnDate = new Date(preferences.returnDate)
                    }

                    adultsNumber = preferences.adultsNumber || 0
                    childrenNumber = preferences.childrenNumber || 0
                    infantsNumber = preferences.infantsNumber || 0
                    currency = preferences.currency
                } catch(err) {
                    console.error(err)
                }
            }
        }
        request.send();
    }
}
