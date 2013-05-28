function search(){
  var price = $('input[name = "price"]').val() || null;
  var type = $('input[name = "type"]').val() || null;
  var creator = $('input[name = "creator"]').val() || null;

  $.ajax({
    type: "GET",
    url: "/search",
    data: ({category: type, price: price, brand: creator}), /*, id: review_id*/
    success: function(data){
      alert('all ok');
    },
    error: function(data){
      alert("something wrong")
    },
    datatype: "json"});
}
