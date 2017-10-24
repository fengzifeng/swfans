function turntableDraw(obj,jsn)
{
	"use strict";
	this.draw = {};
	this.draw.obj = $(obj);
	this.draw.objClass = $(obj).attr("class");
	this.draw.newClass = "rotary"+"new"+parseInt(Math.random()*1000);
	var _jiaodu = parseInt(360/jsn.share);
	var _yuan = 360*(jsn.weeks || 4);
	var _str = "";
	var _speed = jsn.speed || "2s";
	var _velocityCurve = jsn.velocityCurve || "ease";
	var _this = this;
	for(var i=1;i<=jsn.share;i++)
	{
		_str+="."+this.draw.newClass+i+"{";
		_str+="transform:rotate("+((i-1)*_jiaodu+_yuan)+"deg);";
		_str+="-ms-transform:rotate("+((i-1)*_jiaodu+_yuan)+"deg);";
		_str+="-moz-transform:rotate("+((i-1)*_jiaodu+_yuan)+"deg);";
		_str+="-webkit-transform:rotate("+((i-1)*_jiaodu+_yuan)+"deg);";
		_str+="-o-transform:rotate("+((i-1)*_jiaodu+_yuan)+"deg);";
		_str+="transition: transform "+_speed+" "+_velocityCurve+";";
		_str+="-moz-transition: -moz-transform "+_speed+" "+_velocityCurve+";";
		_str+="-webkit-transition: -webkit-transform "+_speed+" "+_velocityCurve+";";
		_str+="-o-transition: -o-transform "+_speed+" "+_velocityCurve+";";
		_str+="}";
		_str+="."+this.draw.newClass+i+"stop{";
		_str+="transform:rotate("+((i-1)*_jiaodu)+"deg);";
		_str+="-ms-transform:rotate("+((i-1)*_jiaodu)+"deg);";
		_str+="-moz-transform:rotate("+((i-1)*_jiaodu)+"deg);";
		_str+="-webkit-transform:rotate("+((i-1)*_jiaodu)+"deg);";
		_str+="-o-transform:rotate("+((i-1)*_jiaodu)+"deg);";
		_str+="}";
	};
	$(document.head).append("<style>"+_str+"</style>");
	_speed = _speed.replace(/s/,"")*1000;
	this.draw.startTurningOk = false;
	this.draw.goto=function(ind){
		if(_this.draw.startTurningOk){return false};
		_this.draw.obj.attr("class",_this.draw.objClass+" "+_this.draw.newClass+ind);
		_this.draw.startTurningOk = true;
		setTimeout(function(){
			_this.draw.obj.attr("class",_this.draw.objClass+" "+_this.draw.newClass+ind+"stop");
			if(jsn.callback)
			{
				_this.draw.startTurningOk = false;
				jsn.callback(ind);
			};
		},_speed+10);
		return _this.draw;
	};
	return this.draw;
};