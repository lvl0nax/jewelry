var services = (function(){

    var t={};
    t.sizeOfObj = function(obj){
        var length = null;
        for (i in obj) {
            length += 1;
        }
        return length;
    };

    return t;
}());

ck = function(key, value, options) {

    if (arguments.length > 1 && (!/Object/.test(Object.prototype.toString.call(value)) || value === null || value === undefined)) {
        options = $.extend({}, options);

        if (value === null || value === undefined) {
            options.expires = -1;
        }

        if (typeof options.expires === 'number') {
            var days = options.expires, t = options.expires = new Date();
            t.setDate(t.getDate() + days);
        }

        value = String(value);

        return (document.cookie = [
            encodeURIComponent(key), '=', options.raw ? value : encodeURIComponent(value),
            options.expires ? '; expires=' + options.expires.toUTCString() : '',
            options.path ? '; path=' + options.path : '',
            options.domain ? '; domain=' + options.domain : '',
            options.secure ? '; secure' : ''
        ].join(''));
    }

    options = value || {};
    var decode = options.raw ? function(s) { return s; } : decodeURIComponent;

    var pairs = document.cookie.split('; ');
    for (var i = 0, pair; pair = pairs[i] && pairs[i].split('='); i++) {
        if (decode(pair[0]) === key) return decode(pair[1] || '');
    }

    return null;

};

var card = (function(){

    var t={};
        t.cardLi = null,
        t.cardWrap = null,
        t.cardObj = {},
        t.cardTotalPrice = null;

    t.init = function(params){

        var cookieCard = ck("card");

        params = $.extend({
            el: $("#list-products li"),
            card: $(".card"),
            cardCheck: $("#card-chekout"),
            cardWrap: $("#card-wrapper")
                 }, params);

        t.card = params.card;
        t.cardLi = params.el;
        t.cardCheck = params.cardCheck;
        t.cardWrap = params.cardWrap;

        var wiLogin = 500 - $(".login").width() - 10;

        t.card.css({
            "margin-right" : -wiLogin
        }).fadeIn(200);

        t.card.click(function(event){
            if(t.card.hasClass("empty")) return false;
            if(!t.card.hasClass("open")){
                t.showCard();
            } else {
                event.stopPropagation();
            }
        });

        if(cookieCard == null || (cookieCard != null && cookieCard.length < 3)){
            t.cardObj = {};
            ck("card", JSON.stringify(t.cardObj),{path : "/"});
            t.cardCheck.html("пуста");
        } else {
            t.cardObj = JSON.parse(cookieCard);
            t.card.removeClass("empty");
            t.writeToCard();
        }

        params.el.click(function(){
            t.addToCard($(this));
        })

    };

    t.showCard = function(){
        t.card.addClass("open");
        t.card.stop().animate({
            "min-width": 350
        }, 300, function(){
            t.cardWrap.stop().slideDown(300, function(){
                $('.links').show();
            });
        });

        $("body").unbind("click");
        t.card.mouseout(function(){
            $("body").bind("click", t.hideCard);
        })
    };

    t.hideCard = function(tO){
        t.card.removeClass("open");
        $('.links').hide();
        t.cardWrap.stop().slideUp(300, function(){
            t.card.stop().animate({
                "min-width": 100}, 300, function(){
            });
        });
    };

    t.addToCard = function(el){

        var id = parseInt(el.attr("data-id")),
            product = null;

        if(id == undefined) {alert("Не указан data-id"); return false;}

        if(t.cardObj != null && t.cardObj[id]){

            t.cardObj[id].count = parseInt(t.cardObj[id].count) + 1;

        } else {
            if (t.cardObj == null) t.cardObj = {};

            product = {
                name : el.attr("data-name"),
                price : parseFloat(el.attr("data-price")).toFixed(2),
                count : 1
            };

            t.cardObj[id] = product;

        }

        t.writeToCard();
    };

    t.deleteItem = function(id){
        delete t.cardObj[id];
        t.writeToCard();
    };

    t.minusOne = function(id){
        if(t.cardObj[id].count < 2){
            delete t.cardObj[id];
        } else {
            t.cardObj[id].count = t.cardObj[id].count - 1;
        }
        t.writeToCard();

        return false;
    };

    t.plusOne = function(id){
        t.cardObj[id].count = t.cardObj[id].count + 1;
        t.writeToCard();
        return false;
    };

    t.emptyCard = function(){
        t.cardObj = {};
        t.writeToCard();
    };

    t.totalSumm = function(){
        var total = 0;

        for(k in t.cardObj){
            total += parseInt(t.cardObj[k].count) * parseFloat(t.cardObj[k].price);
        }

        return total.toFixed(2);
    };

    t.writeToCard = function(){

        ck("card", JSON.stringify(t.cardObj),{path : "/"});

        t.card.removeClass("empty");
        t.cardWrap.html("");
        t.cardTotalPrice = 0;
        t.cardTotalCount = 0;

        for(i in t.cardObj){

            t.cardWrap.append('<div class="nclear">'+
                                '<div class="fl-r">'+
                                '<a class="counters" href="javascript: void(0)" onclick="card.minusOne(' + i + '); event.stopPropagation()"><b>-</b></a>'+
                                ' <span class="count-item">' + t.cardObj[i].count + '</span>'+
                                ' <a href="javascript: void(0)" class="counters" onclick="card.plusOne(' + i + '); event.stopPropagation()"><b>+</b></a>'+
                                ' = ' + (t.cardObj[i].count * t.cardObj[i].price ).toFixed(2) +
                                //'&nbsp; <a href="javascript:" onclick="card.deleteItem('+i+')">del</a>'+
                                '</div>'+
                                t.cardObj[i].name +
                              '</div>');

            t.cardTotalPrice += parseInt(t.cardObj[i].count) * parseFloat(t.cardObj[i].price);
            t.cardTotalCount += parseInt(t.cardObj[i].count);

        }

        t.cardTotalPrice = t.cardTotalPrice.toFixed(2);
        t.cardCheck.html(t.cardTotalCount + " товаров, на сумму: " + t.cardTotalPrice);

        if(services.sizeOfObj(t.cardObj) == null) {
            t.cardCheck.html("пуста");
            t.card.addClass("empty").removeClass("open");
            t.hideCard();
        }

    };

    $(t.init);

    return t;
}());


var check = (function(){
  var t = {};

  t.getNextStep = function(){
    var fioO = $("#fio"),
        mobileNumberO = $("#mobile-number");

    if(fioO.val().length == 0){
        alert("Введите Ваше ФИО");
        fioO.focus();
        return false;
    } else if(mobileNumberO.val().length == 0){
        alert("Введите Ваш мобильный телефон");
        mobileNumberO.focus();
        return false;
    }

    location.href = "card/add_to_card?fio=" + fioO.val() + "&phone=" + mobileNumberO.val();

  };

  t.addOneToCard = function(el, id){

      card.plusOne(id);

      t.writeFromCard();
  };

  t.minusOneFromCard = function(el, id){

      card.minusOne(id);

      t.writeFromCard();
  };

  t.writeFromCard = function(){

    t.table.html("");
    t.tableInner = "<tr class='tr-top'><td>Наименование товара</td><td>Количество</td><td>Цена</td><td class='td-last'>Сумма</td></tr>";
    for(i in card.cardObj){
        t.tableInner += "<tr>"+
                    "<td>" + card.cardObj[i].name + "</td>"+
                    "<td>"+
                        "<a onclick='check.minusOneFromCard($(this), " + i + ")' href='javascript: void(0)'><b>-</b></a>"+
                        " <span class='count'>" + card.cardObj[i].count + "</span>"+
                        " <a onclick='check.addOneToCard($(this), " + i + ")' href='javascript: void(0)'><b>+</b></a>"+
                    "</td>"+
                    "<td>" + card.cardObj[i].price + "</td>"+
                    "<td class='td-last'>" +(card.cardObj[i].count * card.cardObj[i].price ).toFixed(2) + "</td>"+
                "</tr>"
    }
    t.tableInner += "<tr class='tr-bottom'><td class='td-last' colspan='4'>Итог: " + card.cardTotalPrice + "</td></tr>"


    t.table.html(t.tableInner);

    if(services.sizeOfObj(card.cardObj) == null) {
        t.table.html("Корзина пуста, <a href='/'>выберите товар</a> и возвращайтесь!")
    }

  };

  t.init = function(){
    t.table = $('.list-products-card');

    t.writeFromCard();
  };
  $(t.init);
  return t;
}())