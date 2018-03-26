//----------------------------------------------------------------------------------------------------------------------
function messageShow(obj, text1, text2, type) {
    var style;
    if(type === 1) style = 'alert" style="color:red"'; else style = 'success" style="color:green"';
    var html = '<div class="callout padding-top-03 padding-bottom-03 '+style+'>';
    html += '<h6 class="margin-bottom-0">' + text1 + '</h6>';
    if(text2 != null)  html += '<h6 style="color: #0a0a0a; font-size: .9rem">' + text2 + '</h6>';
    html += '</div>';
    //var obj = $('#message');
    obj.html(html);
    obj.slideDown();
}
//----------------------------------------------------------------------------------------------------------------------
function messageHide(obj) {
    obj.slideUp(0);
}
//----------------------------------------------------------------------------------------------------------------------
function convertDateNowToString() {
    var date = new Date();
    var day = date.getDate();
    var month = date.getMonth() + 1;
    var year = date.getFullYear();
    if (month < 10) month = "0" + month;
    if (day < 10) day = "0" + day;
    return year + "-" + month + "-" + day;
}