var antiForgeryTokenFieldName = "__RequestVerificationToken";

function getAntiForgeryTokenFromForm(formElement) {
    if (formElement != null) {
        var antiForgeryElementCollection = $(formElement)
            .children("input[name='" + antiForgeryTokenFieldName + "']");
            
        if (antiForgeryElementCollection.length > 0) {
            var antiForgeryElement = antiForgeryElementCollection.first();
            var antiForgeryToken = antiForgeryElement.val();
            return antiForgeryToken;
        }
    }

    return null;
}

function getAntiForgeryTokenForFormChild(formChildElement) {
    var formElementCollection = $(formChildElement).parents("form");
    
    if (formElementCollection.length > 0) {
        var formElement = formElementCollection.first();
        return getAntiForgeryTokenFromForm(formElement);
    }

    return null;
}

function getAntiForgeryTokenForFormChildEvent(event) {
    event = event || window.event;
    
    if (event != null) {
        var formChildElement = event.srcElement;
        
        if (formChildElement != null) {
            return getAntiForgeryTokenForFormChild(formChildElement);
        }
    }
    
    return null;
}