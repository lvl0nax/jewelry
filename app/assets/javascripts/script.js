
function add_to_cart(product_id){

  $.ajax({
    type: "GET",
    url: "/card/add_to_cart",
    data: ({product: product_id}),
    success: function(data){
      /*alert('all ok');*/
      var temp;
      $('#scrollbar-content').html('').html(data.responseText);
      temp = $('.basket-item-price').toArray();
      var ttt = 0.0;
      temp.forEach(function(i){ttt = ttt + parseFloat(i.textContent)});
      $('#total').html('').html(ttt + 'p.')
    },
    error: function(data){
      var temp;
      $('#scrollbar-content').html('').html(data.responseText);
      temp = $('.basket-item-price').toArray();
      var ttt = 0.0;
      temp.forEach(function(i){ttt = ttt + parseFloat(i.textContent)});
      $('#total').html('').html(ttt + 'p.')
      /*alert("something wrong")*/
    }});
}

function remove_from_cart(product_id){
  $.ajax({
    type: "GET",
    url: "/card/remove_from_cart",
    data: ({product: product_id}),
    success: function(data){
      /*alert('all ok');*/
      var temp;
      $('#scrollbar-content').html('').html(data.responseText);
      temp = $('.basket-item-price').toArray();
      var ttt = 0.0;
      temp.forEach(function(i){ttt = ttt + parseFloat(i.textContent)});
      $('#total').html('').html(ttt + 'p.')
    },
    error: function(data){
      var temp;
      $('#scrollbar-content').html('').html(data.responseText);
      temp = $('.basket-item-price').toArray();
      var ttt = 0.0;
      temp.forEach(function(i){ttt = ttt + parseFloat(i.textContent)});
      $('#total').html('').html(ttt + 'p.')
      basketScroller.update(false, true);
      /*alert("something wrong")*/
    }});
}
/* scrollbar */
function Scrollbar(el, options) {

    var self = this;

    options = self.options = options || {};

    self.wrap = $(ge(el));

    self.inner = self.wrap.children().css({ overflow: ('hidden') });

    self.el = self.inner[0];
    self.content = self.inner.children();

    self.scrollHeight = self.inner.height();
    self.scrollbar = $('<div class="scrollbar-wrap"></div>').css({ right: 0, height: self.scrollHeight });
    self.scrollbar_inner = $('<div class="scrollbar-inner"></div>').appendTo(this.scrollbar);
    self.topShadowDiv = $('<div class="scrollbar-top"></div>');
    self.bottomShadowDiv = $('<div class="scrollbar-bottom"></div>');

    self.wrap.append(self.scrollbar).append(self.topShadowDiv).append(self.bottomShadowDiv);

    self.mouseMove = self._mouseMove.bind(self);
    self.mouseUp = self._mouseUp.bind(self);

    function down(event) {
        if (self.moveY || checkEvent(event)) return;
        $(document).bind('mousemove', self.mouseMove).bind('mouseup', self.mouseUp);
        self.moveY = app.mouseY - (parseInt(self.scrollbar_inner.css('marginTop')) || 0);

        window.document.body.style.cursor = 'pointer';
        self.scrollbar_inner.addClass('scrollbar-drag');
        cancelEvent(event);
    }

    var wheel = this.wheel.bind(this);

    self.inner.bind('mousewheel DOMMouseScroll', wheel);
    self.scrollbar_inner.bind('mousedown', down);

    // touch
    var touchstart = function(event) {
        event = event.originalEvent;
        self.touchY  = event.touches[0].pageY;
    };
    var touchmove = function(event) {
        event = event.originalEvent;
        var touchY = event.touches[0].pageY;
        self.touchDiff = self.touchY - touchY;
        self.el.scrollTop += self.touchDiff;
        self.touchY = touchY;
        if (self.el.scrollTop > 0 && self.shown !== false) {
            self.update(true);
            cancelEvent(event);
        }
    };
    var touchend = function() {
        self.animateInt = setInterval(function(){
            self.touchDiff = self.touchDiff * 0.9;
            if (self.touchDiff < 1 && self.touchDiff > -1) {
                clearInterval(self.animateInt);
            } else {
                self.el.scrollTop += self.touchDiff;
                self.update(true);
            }
        }, 0);
    };
    self.inner.bind('touchstart', touchstart);
    self.inner.bind('touchmove', touchmove);
    self.inner.bind('touchend', touchend);

    this.inited = true;
    this.update(true);
};

Scrollbar.prototype._mouseMove = function(event) {
    this.el.scrollTop = Math.floor((this.contHeight() - this.scrollHeight) * Math.min(1, (app.mouseY - this.moveY) / (this.scrollHeight - this.innerHeight)));
    this.update(true);
    return false;
};

Scrollbar.prototype._mouseUp = function(event) {
    this.moveY = false;
    $(document).unbind('mousemove', self.mouseMove).unbind('mouseup', self.mouseUp);
    window.document.body.style.cursor = 'default';
    this.scrollbar_inner.removeClass('scrollbar-drag');
    return false;
};

Scrollbar.prototype.wheel = function(event) {
    if (this.disabled) {
        return;
    }
    event = event.originalEvent;
    var delta = 0;
    if (event.wheelDeltaY || event.wheelDelta) {
        delta = (event.wheelDeltaY || event.wheelDelta) / 2;
    } else if (event.detail) {
        delta = -event.detail * 10
    }
    var stWas = this.el.scrollTop;

    this.el.scrollTop -= delta;

    if (stWas != this.el.scrollTop && this.shown !== false) {
        this.update(true);
        this.scrollbar_inner.addClass('scrollbar-hovered');
        clearTimeout(this.moveTimeoput);
        this.moveTimeoput = setTimeout((function() {
            this.scrollbar_inner.removeClass('scrollbar-hovered');
        }).bind(this), 300);
    }
    if (this.shown) {
        return false;
    }
};

Scrollbar.prototype.hide = function() {
    this.topShadowDiv.hide();
    this.bottomShadowDiv.hide();
    this.scrollbar.hide();
    this.hidden = true;
};
Scrollbar.prototype.show = function() {
    this.topShadowDiv.show();
    this.bottomShadowDiv.show();
    this.scrollbar.show();
    this.hidden = false;
};
Scrollbar.prototype.disable = function() {
    this.hide();
    this.scrollToY(0);
    this.disabled = true;
};
Scrollbar.prototype.enable = function() {
    this.show();
    this.update();
    this.disabled = false;
};

Scrollbar.prototype.scrollToY = function(top) {
    this.el.scrollTop = parseInt(top);
    this.update(false, true);
};

Scrollbar.prototype.contHeight = function() {
    var self = this;
    if (!self.contentHeight) {
        self.contentHeight = 0;
        self.content.each(function(){
            self.contentHeight += $(this).height();
        });
    }
    return self.contentHeight;
};

Scrollbar.prototype.val = function(value) {
    if (value) {
        this.el.scrollTop = value;
        this.update(true, true);
    }
    return this.el.scrollTop;
};

Scrollbar.prototype.update = function(noChange, updateScroll) {
    if (!this.inited || this.hidden) {
        return;
    }
    if (!noChange) {
        this.contentHeight = false;
        if (this.moveY) {
            return true;
        }
    }
    if (updateScroll) {
        this.scrollHeight = this.inner.height();
        this.scrollbar.css('height', this.scrollHeight);
    }
    var height = this.contHeight();
    if (height <= this.scrollHeight) {
        this.scrollbar_inner.hide();
        this.bottomShadowDiv.hide();
        this.topShadowDiv.hide();
        this.topShadow = this.bottomShadow = false;
        this.shown = false;
        return;
    } else if (!this.shown) {
        this.scrollbar_inner.show();
        this.shown = true;
    }

    var topScroll = this.val();

    var progress = this.lastProgress = Math.min(1, topScroll / (height - this.scrollHeight));

    if (progress > 0 != (this.topShadow ? true : false)) {
        this.topShadowDiv[(this.topShadow ? 'hide' : 'show')]();
        this.topShadow = !this.topShadow;
    }
    if (progress < 1 != (this.bottomShadow ? true : false)) {
        this.bottomShadowDiv[(this.bottomShadow ? 'hide' : 'show')]();
        this.bottomShadow = !this.bottomShadow;
    }

    this.innerHeight = Math.max(40, Math.floor(this.scrollHeight * this.scrollHeight / height));
    this.scrollbar_inner.css({ height: this.innerHeight, marginTop: Math.floor((this.scrollHeight - this.innerHeight) * progress) });

    if (this.options.more && height - this.el.scrollTop < this.scrollHeight * 2) {
        this.options.more();
    }
};


/**
 fsSelect Module.
 version 1.2
 26.12.2012
 */
var fsSelect = function(opts){
    var self = this;
    self.ajaxLock = false;
    self.disabled = false;
    self.bufferText = "";

    self.construct = function(){
        if(!opts.element) {console.log("Add selector on element to options"); return;}
        if(!opts.array || opts.array.length == 0) {console.log("Array must have minimum 1 element"); return;}

        $.extend(self, opts);
        fsSelect.cache[self.element] = self;
        self.wrapper = $(self.element);
        if(self.wrapper.length == 0) {console.log("Wrapper not found, check selector in options"); return;}

        self.inputValue = $("<input>", {'type': 'hidden', 'name': self.name});
        self.header = $("<div>", {'class': 'form-select-header tr-01'}).append('<i class="form-select-down"></i>');
        self.inputFinder = $("<input>", {
            'class': 'form-select-input',
            'placeholder': self.placeholder ? self.placeholder : ''
        });
        if(self.readonly) self.inputFinder.attr('readonly', 'readonly').addClass('readonly');
        self.header.prepend(self.inputFinder);
        self.wrapper.append(self.header).append(self.inputValue);
        self.update();

        /* events */
        self.inputFinder.bind('keyup', function(event){return _search(event);});
        self.inputFinder.bind('keydown', function(event){return _keyEvent(event);});
        self.inputFinder.bind('focus', function(){self.showFinder();});
        self.inputFinder.click(function(event){

            if(self.readonly){
                if( self.wrapper.hasClass('opened') ){ fsSelect.hideFinder('close'); }
                else { self.showFinder(); }
            } else {
                self.showFinder(); sp(event);
            }
        });
        self.header.click(function(event){
            if(self.wrapper.hasClass('opened')){ fsSelect.hideFinder('close'); }
            else { self.showFinder(); }
        });
    };

    self.change = function(num, fromHide){
        var buffer = self.inputValue.val();
        if(self.array[num][3]) return;

        for(var i in self.array){self.array[i][2] = 0;}

        self.array[num][2] = 1;
        self.update();

        if(self.wrapper.hasClass('opened') && !fromHide) fsSelect.hideFinder('close', true);
        if(typeof(self.onchange) == 'function' && buffer != self.inputValue.val()) self.onchange(self.array[num], self);
    };

    self.disable = function(){self.disabled = true; self.wrapper.addClass('form-select-disabled');self.inputFinder.attr('disabled', 'true');};
    self.undisable = function(){self.disabled = false; self.wrapper.removeClass('form-select-disabled');self.inputFinder.removeAttr('disabled');};

    self.update = function(){
        self.selectedNum = null;

        for(var i in self.array){ if(self.array[i][2]) self.selectedNum = i; }

        if(self.selectedNum || self.selectedNum == 0) {
            self.inputFinder.val(self.array[self.selectedNum][1]);
            self.inputValue.val(self.array[self.selectedNum][0]);
        } else {
            self.inputFinder.val("");
            self.inputValue.val("");
        }
    };

    self.ajaxOn = function(){return self.ajax_url;};
    self.ajaxData = [];
    self.ajax = function(){
        if(self.ajaxLock){return;}

        self.bufferText = self.inputFinder.val();

        var params = {query: self.bufferText};

        if(typeof(self.beforeajax) == 'function') params = self.beforeajax(params, self) ? self.beforeajax(params, self) : params;

        self.ajaxLock = true;

        _ajax.post(self.ajax_url, params, function(html, status, data){
            self.ajaxLock = false;
            if(typeof(self.onajax) == 'function') data = self.onajax(data, self);

            self.ajaxData = data;

            html = self.render(data, true, self.bufferText, true);
            self.finderBox.html(html);

            if(self.bufferText != self.inputFinder.val()){
                self.ajax();
            }
        })
    };

    self.ajaxChange = function(num){
        var addFlag = true;
        for(var i in self.array){
            if(self.array[i][0] == self.ajaxData[num][0]){
                self.change(i);
                addFlag = false;
            }
        }
        if(addFlag){
            self.array.push([self.ajaxData[num][0], self.ajaxData[num][1], self.ajaxData[num][2], self.ajaxData[num][3]]);
            self.change(self.array.length - 1);
        }
    };

    self.showFinder = function(){
        if(fsSelect.current == self.element) {return;}
        if(self.disabled) {return;}
        else {
            $(document)
                .unbind('click', fsSelect.hideFinder)
                .bind('click', fsSelect.hideFinder);
            var offsetPosition = self.wrapper.offset(),
                headerHeight = self.header.outerHeight(),
                headerWidth = self.header.outerWidth();

            fsSelect.current = self.element;
            self.wrapper.addClass('opened');
            self.finderBox = $("#form-selector-box");
            if(self.finderBox.length == 0) self.finderBox = $('<div>', {'id' :'form-selector-box', 'onclick' : "sp(event)"}).appendTo("#node-heap");

            self.finderBox.css({
                'left' : offsetPosition.left,
                'top' : offsetPosition.top + headerHeight + 2,
                'width' : headerWidth - 1,
                'display': 'block',
                'z-index': (self.selectIndex ? self.selectIndex : 2)
            }).html("");

            var html = self.render(self.array);
            self.finderBox.html(html);
        }
    };

    self.render = function(data, isSearch, text, isAjaxRender){
        var r = "";
        var reSearch = new RegExp('(' + text + ')', 'i')
        for(var i in data){
            if(!data[i][3] && ( (isSearch && (reSearch).test(data[i][1])) || !isSearch ) ){
                r+='<div class="form-selector-item ' +
                    ( data[i][2] && !isSearch ? "selected" : "") +
                    ( data[i][3] ? "disabled" : "") +
                    '" onclick="fsSelect.cache[\'' + self.element + '\'].' + (isAjaxRender ? 'ajaxChange' : 'change' )+ '(' + i + ');">'+
                    (isAjaxRender ? (isSearch ? data[i][4].replace(reSearch, "<span class='finded'>$1</span>"): data[i][4]) : (isSearch ? data[i][1].replace(reSearch, "<span class='finded'>$1</span>"): data[i][1])) +
                    '</div>';
            }
        }
        if(r.length == 0) {
            r='<div class="form-selector-result">Ничего не найдено</div>';
        } else{
            r=(self.finderTitle ? '<div class="form-selector-result">' + self.finderTitle + '</div>' : '') + r;
        }
        return r;
    };


    var _search = function(event){
        var inputEl = self.inputFinder,
            inputElVal = inputEl.val(), notSearchKeys = [9, 27, 37, 38, 39, 40];
        if(indexOf(notSearchKeys,event.keyCode) != -1) return;

        if(inputElVal.length == 0) {
            self.finderBox.html(self.render(self.array));
        } else {
            if(self.ajaxOn()){
                self.ajax();
            } else {
                self.finderBox.html(self.render(self.array, true, inputElVal));
            }
        }
    };

    var _keyEvent = function(event){
        var kc = event.keyCode;
        if(kc == 27){
            fsSelect.hideFinder('close');
        } else if(kc == 9){
            fsSelect.hideFinder('close');
        } else if(kc == 13){
            var selectedElement = self.finderBox.find('.selected');
            if(selectedElement){ selectedElement.click();}
            else{fsSelect.hideFinder('close');}
            return false;
        } else if(kc == 38){
            var selectedElement = self.finderBox.find('.selected');
            if(selectedElement){
                selectedElement.removeClass('selected');
                var prev = selectedElement.prev();
                if(prev && prev.hasClass('form-selector-item')){
                    prev.addClass('selected');
                    if(self.finderBox.find('.selected')[0].offsetTop < self.finderBox[0].scrollTop) {
                        self.finderBox[0].scrollTop = self.finderBox.find('.selected')[0].offsetTop;
                    }
                } else {
                    self.finderBox.find('.form-selector-item:last').addClass('selected');
                    self.finderBox[0].scrollTop = self.finderBox.height();
                }
            }
            return false;
        } else if(kc == 40){
            var selectedElement = self.finderBox.find('.selected');
            if(selectedElement){

                selectedElement.removeClass('selected');

                var next = selectedElement.next();
                if(next && next.hasClass('form-selector-item')){
                    next.addClass('selected');

                    if(self.finderBox.find('.selected')[0].offsetTop + self.finderBox.find('.selected').outerHeight() > self.finderBox.height() + self.finderBox[0].scrollTop) {
                        self.finderBox[0].scrollTop = (self.finderBox.find('.selected')[0].offsetTop - self.finderBox.height()+ self.finderBox.find('.selected').outerHeight());
                    }
                } else {
                    self.finderBox.find('.form-selector-item:first').addClass('selected');
                    self.finderBox[0].scrollTop = 0;
                }
            }
            return false;
        }
        sp(event);
    };

    self.construct();
};

fsSelect.cache = {};
fsSelect.current = null;
fsSelect.hideFinder = function(event, force){
    if((typeof(event) != 'string' && $(event.target).closest('.form-select-wrap').length == 0) || event == 'close'){
        $(document).unbind('click', fsSelect.hideFinder);
        var currentSelect = fsSelect.cache[fsSelect.current], flagFinded = false;
        if(!force){
            for(var i in currentSelect.array){
                if(currentSelect.array[i][1] == currentSelect.inputFinder.val() && !currentSelect.array[i][3]){
                    currentSelect.change(i, true);
                    flagFinded = true;
                }
            }
        }

        if(!flagFinded){currentSelect.update();}
        currentSelect.inputFinder.blur();
        $('#form-selector-box').html("").hide();
        $('.form-select-wrap').removeClass('opened');
        fsSelect.current = null;
    }
};

// utils
function trim(text) {return (text || '').replace(/^\s+|\s+$/g, '');}
function htmlspecialchars(s) { return s.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#039;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }
function indexOf(arr, value, from){ for (var i = from || 0, l = arr.length; i < l; i += 1) if (arr[i] == value) return i; return -1; }
function isEmpty(o){ for (var p in o) { if (o.hasOwnProperty(p)) return false; } return true; }
function rand(min, max){ return max ? Math.floor(Math.random() * (max - min + 1)) + min : Math.floor(Math.random() * (min + 1)); }
function fsNow(){ return +new Date; }
function ge(el){ return (typeof el == 'string' ? document.getElementById(el) : el); };
function st(f, t){ return setTimeout(function(){ safe_call('set_timeout', f); }, t); }
function si(f, t){ return setInterval(function(){ safe_call('set_interval', f); }, t); }
function checkEvent(e) {
    e = e || window.event || {};
    e = e.originalEvent || e;
    return (e.type == "click" || e.type == "mousedown" || e.type == "mouseup") && (e.which > 1 || e.button > 1 || e.ctrlKey || e.shiftKey || browser.mac && e.metaKey);
}
function sp(e){ e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; }
function pd(e){ e.preventDefault ? e.preventDefault() : e.returnValue = false; }
function cancelEvent(e) {
    e = e || window.event || {};
    e = e.originalEvent || e;
    sp(e);
    pd(e);
}
/* browser */
(function(_ua){
    window.browser = {
        version: (_ua.match(/.+(?:me|ox|on|rv|it|era|ie)[\/: ]([\d.]+)/) || [0, '0'])[1],
        msie: /msie/.test(_ua) && !/opera/.test(_ua),
        opera: /opera/.test(_ua),
        mozilla: /firefox/.test(_ua),
        chrome: /chrome/.test(_ua),
        safari: !/chrome/.test(_ua) && /webkit|safari|khtml/.test(_ua),
        mobile: /iphone|ipod|ipad|opera mini|opera mobi|iemobile/.test(_ua),
        mac: /mac/.test(_ua)
    };
})(navigator.userAgent.toLowerCase());

var app = {};

$(function(){
    var w = $(window);
    var windowSize = function(){
        app.windowW = w.width();
        app.windowH = w.height();
    };
    windowSize();
    app.idle = !1;
    $(window).bind('blur', function(){ app.idle = !0; });
    $(window).bind('focus', function(){ app.idle = !1; });
    var windowScroll = function(){
        app.scrollTop = w.scrollTop();
    };
    windowScroll();
    w.resize(windowSize).scroll(windowScroll);
    app.mouseX = 0;
    app.mouseY = 0;
    function getXY(e){
        var e = e || window.event, posx = 0, posy = 0;
        if(e.pageX || e.pageY) {
            posx = e.pageX;
            posy = e.pageY;
        } else if(e.clientX || e.clientY) {
            posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
            posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
        }
        app.mouseX = posx;
        app.mouseY = posy;
    };
    document.onmousemove = getXY;
});

// set context
Function.prototype.bind = function() {
    var func = this, args = Array.prototype.slice.call(arguments);
    var obj = args.shift();
    return function() {
        var curArgs = Array.prototype.slice.call(arguments);
        return func.apply(obj, args.concat(curArgs));
    }
};

var basket = new function(){
    var _basket = this, $basket;

    _basket.open = function(){
        if(!$basket) $basket = $('#basket');
        $basket.slideDown(200, function(){
            basketScroller.update(false, true);
            $('body').bind('click', basket.hide);
        });
    };

    _basket.hide = function(event){
        var _target = $(event.target);
        if(!_target.closest('#basket').length){
            $basket.slideUp(200, function(){
                $('body').unbind('click', basket.hide);
            });
        }
    }
};

var gallery = new function(){
    var gy = this;

    gy.current = 0;
    gy.wrapper = $('#gallery-big-show');
    gy.ids = [];

    gy.init = function(opts){
        $.extend(self, opts);

        $('.gallery-item').each(function(){
            gy.ids.push($(this).data('id'));
        });

        gy.current = 0;
    };

    gy.show = function(id){
        $('.gallery-product-info').fadeOut(100);
        $('.gallery-big-img').fadeOut(100);

        $('#gallery-product-info-' + id).fadeIn(100);
        $('#gallery-big-img-' + id).fadeIn(100);

        gy.current = indexOf(gy.ids, id);
    };

    gy.next = function(){
        gy.current = (gy.current  == gy.ids.length - 1) ? 0 : gy.current + 1;
        gy.show(gy.ids[gy.current]);
    };

    gy.prev = function(){
        gy.current = (gy.current  == 0) ? gy.ids.length - 1 : gy.current - 1;
        gy.show(gy.ids[gy.current]);
    };
};

function search(){
  var price = $('input[name = "price"]').val() || null;
  var type = $('input[name = "type"]').val() || null;
  var creator = $('input[name = "creator"]').val() || null;

  $.ajax({
    type: "GET",
    url: "/search",
    data: ({category: type, price: price, brand: creator}), /*, id: review_id*/
    success: function(data){
      /*alert(data);*/
      $('#yield-right-side').html(data);
    },
    error: function(data){
      alert("something wrong")
    },
    datatype: "json"});
}
