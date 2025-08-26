function hyperlinkTopicField(rowData, userLCID) {
    var topic = rowData.getValue("subject"); // internal name for Topic
    var id = rowData.getId();

    if (topic && id) {
        return "<a href='#' onclick=\"openLead('" + id + "')\">" + topic + "</a>";
    }
    return topic;
}

function openLead(id) {
    var pageInput = {
        pageType: "entityrecord",
        entityName: "lead",
        entityId: id
    };
    var navigationOptions = {
        target: 2, // Opens in a new window
        width: 800,
        height: 600,
        position: 1
    };
    Xrm.Navigation.navigateTo(pageInput, navigationOptions);
}
