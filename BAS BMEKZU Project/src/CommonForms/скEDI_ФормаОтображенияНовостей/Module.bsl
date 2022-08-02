
&НаСервере
Процедура ВывестиНовостиНаФорму(ПолученыНовости)
	ПолеНовости0    = "";	
	СсылкаНаНовость = "";
	ФотоНовости     = "";
	ДатаНовости      = "";
	
	Если ЗначениеЗаполнено(ПолученыНовости) Тогда
		НомерНовости = 1;
		Для Каждого Новость Из ПолученыНовости Цикл
			ЗаголовокНовости = "";
			Дата 	  = "";
			Текст     = "";
			Если Новость.Свойство("Header", ЗаголовокНовости) Тогда
				
			ИначеЕсли Новость.Свойство("subject", ЗаголовокНовости) Тогда
				
			КонецЕсли;;
			
			Если Новость.Свойство("Published", ДатаНовости) Тогда
				ДатаНовоси = Лев(ДатаНовоси, 10);
			ИначеЕсли Новость.Свойство("date", ДатаНовости) Тогда
				ДатаНовоси = Лев(ДатаНовоси, 10);
			КонецЕсли;
			
			Если Новость.Свойство("Text", Текст) Тогда
				
			ИначеЕсли Новость.Свойство("html", Текст) Тогда
				
			КонецЕсли;
			
			Если Новость.Свойство("link", СсылкаНаНовость) Тогда
				
			КонецЕсли;
			
			Если Новость.Свойство("photo", ФотоНовости) Тогда
				
			КонецЕсли;
			
			СформироватьМодульНовости(ПолеНовости0, ЗаголовокНовости, ДатаНовости, ФотоНовости, Текст, СсылкаНаНовость);
		КонецЦикла;
		
		ПолеНовости = ОбработатьНовости(ПолеНовости0);
	Иначе
		ПолеНовости = ОбработатьНовости(НСтр("ru = 'Нет свежих новостей.'; uk = 'Немає свіжих новин.'"));
		//ПолеНовости = НСтр("ru = 'Нет свежих новостей.'; uk = 'Немає свіжих новин.'");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьМодульНовости(ПолеНовости0, ЗаголовокНовости, ДатаНовости, ФотоНовости, Текст, СсылкаНаНовость)
	ПолеНовости0 = ПолеНовости0 + "
	|<div class=""post"">
	|<section>
	|<img src=" + ФотоНовости +
	"  class=""padding"">
	|
	|<h2><strong>" + ЗаголовокНовости +
	"</strong></h2>
	|
	|<p class=""date"">" +  ДатаНовости +
	"</p>
	|
	|<div class=""Text"">
	|<p>" + Текст +
	"</p>
	|</div>
	|
	|</div>
	|</section>
	|";
КонецПроцедуры


&НаСервере
Функция ПолучитьДатуПоследнегоПолученияНовостей()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	скEDI_ДатаПоследнегоПолученияНовостей.ДатаПолученияНовостей
		|ИЗ
		|	РегистрСведений.скEDI_ДатаПоследнегоПолученияНовостей КАК скEDI_ДатаПоследнегоПолученияНовостей
		|ГДЕ
		|	скEDI_ДатаПоследнегоПолученияНовостей.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", скEDI_НастройкиПодКонфигурацию.ПолучитьТекущегоПользователя());
	
	ВыборкаДата = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаДата.Следующий() Тогда
		Возврат ВыборкаДата.ДатаПолученияНовостей;
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьНовостиНаДату(ДатаНачалаНовостей)
	ДатаНачалаНовостей = ?(ЗначениеЗаполнено(ДатаНачалаНовостей), ДатаНачалаНовостей, ДобавитьМесяц(ТекущаяДата(), -1));
	лпПараметрыКомандыEDIПровайдеру = Новый Структура("FromTime", Формат(ДатаНачалаНовостей, "ДЛФ=DT"));
	ОтветEDIПровайдера = скEDI_КомандыEDIПровайдеру.ПолучитьРезультатКомандыEDIПровайдеру("news/get", лпПараметрыКомандыEDIПровайдеру, Ложь);
	СтруктураНовости = Новый Структура;
	ОтветEDIПровайдера.Свойство("Items", СтруктураНовости);
	
	Возврат СтруктураНовости;
КонецФункции

&НаСервере
Процедура УстановитьДатуПоследнихНовостей()
	МенеджерЗаписиДатаПоследнихНовостей = РегистрыСведений.скEDI_ДатаПоследнегоПолученияНовостей.СоздатьМенеджерЗаписи();
	МенеджерЗаписиДатаПоследнихНовостей.Пользователь 		  = скEDI_НастройкиПодКонфигурацию.ПолучитьТекущегоПользователя();
	МенеджерЗаписиДатаПоследнихНовостей.ДатаПолученияНовостей = ТекущаяДата();
	МенеджерЗаписиДатаПоследнихНовостей.Записать(Истина);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФормаОткрытаИзРабочегоСтолаFlyDoc = Ложь;
	Параметры.Свойство("ФормаОткрытаИзРабочегоСтолаFlyDoc", ФормаОткрытаИзРабочегоСтолаFlyDoc);
	
	Новости = ПолучитьНовостиНаДату(ПолучитьДатуПоследнегоПолученияНовостей());
	Если ФормаОткрытаИзРабочегоСтолаFlyDoc И Не ЗначениеЗаполнено(Новости) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	ВывестиНовостиНаФорму(Новости);	
КонецПроцедуры

&НаКлиенте
Процедура ОзнакомилсяСНовостями(Команда)
	УстановитьДатуПоследнихНовостей();
	Закрыть();
КонецПроцедуры

&НаСервере
Функция ОбработатьНовости(Текстовка)
	JS1 = ВставитьJS1();
	JS2 = ВставитьJS2();

	ШапкаHTML =  "<!doctype html>
	|<html>
	|<head>
	|<meta charset=""utf-8"">
	|<link  rel=""stylesheet"" type=""text/css"">
	|</head>
	|
	|<style>
	|body {
	|	width: 95%;
	|	padding: 40px;
	|	margin: 15px auto;
	|	background-color: #FFFFF;
	|	border-radius: 30px;
	|}
	|</style>
	|
	|<style>
	|html {
	|	padding-top: 5px;
	|}
	|</style>
	|
	|<style>
	|.post {
	|	padding: 7px;
	|	border: 1px solid #ccc;
	|	margin-right: 30px;
	|}
	|</style>
	|
	|<style>
	|img {
	|   
	|	float: left;
	|    margin-right: 30px;
	|    margin-bottom: 18px;
	|    margin-top: 23px;
	|	background: #fff;
	|	padding: 1px;
	|    -webkit-box-shadow: 3px 3px 6px 4px #888;
	|    -moz-box-shadow: 3px 3px 6px 4px #888;
	|    box-shadow: 1px 1px 4px 2px #888;
	|
	|}
	|</style>
	|
	|<style>
	|.post {
	|   margin-right: 30px;
	|   margin-bottom: 15px;
	|   margin-top: 30px;
	|   margin-left: 30px;
	|   border: 25px solid #FFFFF;           
	|   -webkit-box-shadow: 3px 3px 6px 4px #888;
	|   -moz-box-shadow: 3px 3px 6px 4px #888;
	|   box-shadow: 1px 1px 4px 2px #888;
	|   padding-top: 5px;
	|   padding-bottom: 5px;
	|   padding-right:20px;
	|   padding-left: 20px;
	|}
	|</style>
	|<body>	
	|<div>";

	ПодвалHTML = "</div>"
	 + JS1 + JS2 +  
	"
	|</body>
	|</html>  ";

	ГотовыйВидНовостей = ШапкаHTML + Текстовка + ПодвалHTML;

	Возврат ГотовыйВидНовостей;
КонецФункции

&НаСервере
Функция ВставитьJS1()
	JS1 = "
	|
	|<script src=""http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js""></script>
	|
	|<script>
	|;(function($) {
	|
	|  var readmore = 'readmore',
	|      defaults = {
	|        speed: 100,   
	|        maxHeight: 200,
	|        heightMargin: 16,
	|        moreLink: '<a href=""#"">Read More</a>',
	|        lessLink: '<a href=""#"">Close</a>',
	|        embedCSS: true,
	|        sectionCSS: 'width: 100%;',
	|        startOpen: false,
	|        expandedClass: 'readmore-js-expanded',
	|        collapsedClass: 'readmore-js-collapsed',
	|
	|        // callbacks
	|        beforeToggle: function(){},
	|        afterToggle: function(){}
	|      },
	|      cssEmbedded = false;
	|
	|  function Readmore( element, options ) {
	|    this.element = element;
	|
	|    this.options = $.extend( {}, defaults, options);
	|
	|    $(this.element).data('max-height', this.options.maxHeight);
	|    $(this.element).data('height-margin', this.options.heightMargin);
	|
	|    delete(this.options.maxHeight);
	|
	|    if(this.options.embedCSS && ! cssEmbedded) {
	|      var styles = '.readmore-js-toggle, .readmore-js-section { ' + this.options.sectionCSS + ' } .readmore-js-section { overflow: hidden; }';
	|
	|      (function(d,u) {
	|        var css=d.createElement('style');
	|        css.type = 'text/css';
	|        if(css.styleSheet) {
	|            css.styleSheet.cssText = u;
	|        }
	|        else {
	|            css.appendChild(d.createTextNode(u));
	|        }
	|        d.getElementsByTagName('head')[0].appendChild(css);
	|      }(document, styles));
	|
	|      cssEmbedded = true;
	|    }
	|
	|    this._defaults = defaults;
	|    this._name = readmore;
	|
	|    this.init();
	|  }
	|
	|  Readmore.prototype = {
	|
	|    init: function() {
	|      var $this = this;
	|
	|      $(this.element).each(function() {
	|        var current = $(this),
	|            maxHeight = (current.css('max-height').replace(/[^-\d\.]/g, '') > current.data('max-height')) ? current.css('max-height').replace(/[^-\d\.]/g, '') : current.data('max-height'),
	|            heightMargin = current.data('height-margin');
	|
	|        if(current.css('max-height') != 'none') {
	|          current.css('max-height', 'none');
	|        }
	|
	|        $this.setBoxHeight(current);
	|
	|        if(current.outerHeight(true) <= maxHeight + heightMargin) {
	|          // The block is shorter than the limit, so there's no need to truncate it.
	|          return true;
	|       }
	|        else {
	|          current.addClass('readmore-js-section ' + $this.options.collapsedClass).data('collapsedHeight', maxHeight);
	|
	|          var useLink = $this.options.startOpen ? $this.options.lessLink : $this.options.moreLink;
	|          current.after($(useLink).on('click', function(event) { $this.toggleSlider(this, current, event) }).addClass('readmore-js-toggle'));
	|
	|          if(!$this.options.startOpen) {
	|            current.css({height: maxHeight});
	|          }
	|        }
	|      });
	|
	|      $(window).on('resize', function(event) {
	|        $this.resizeBoxes();
	|      });
	|    },
	|
	|    toggleSlider: function(trigger, element, event)
	|    {
	|      event.preventDefault();
	|
	|      var $this = this,
	|          newHeight = newLink = sectionClass = '',
	|          expanded = false,
	|          collapsedHeight = $(element).data('collapsedHeight');
	|
	|      if ($(element).height() <= collapsedHeight) {
	|        newHeight = $(element).data('expandedHeight') + 'px';
	|        newLink = 'lessLink';
	|        expanded = true;
	|        sectionClass = $this.options.expandedClass;
	|      }
	|
	|      else {
	|        newHeight = collapsedHeight;
	|        newLink = 'moreLink';
	|        sectionClass = $this.options.collapsedClass;
	|      }
	|
	|      // Fire beforeToggle callback
	|      $this.options.beforeToggle(trigger, element, expanded);
	|
	|      $(element).animate({'height': newHeight}, {duration: $this.options.speed, complete: function() {
	|          // Fire afterToggle callback
	|          $this.options.afterToggle(trigger, element, expanded);
	|
	|          $(trigger).replaceWith($($this.options[newLink]).on('click', function(event) { $this.toggleSlider(this, element, event) }).addClass('readmore-js-toggle'));
	|
	|          $(this).removeClass($this.options.collapsedClass + ' ' + $this.options.expandedClass).addClass(sectionClass);
	|        }
	|      });
	|    },
	|
	|    setBoxHeight: function(element) {
	|      var el = element.clone().css({'height': 'auto', 'width': element.width(), 'overflow': 'hidden'}).insertAfter(element),
	|          height = el.outerHeight(true);
	|
	|      el.remove();
	|
	|      element.data('expandedHeight', height);
	|    },
	|
	|    resizeBoxes: function() {
	|      var $this = this;
	|
	|      $('.readmore-js-section').each(function() {
	|        var current = $(this);
	|
	|        $this.setBoxHeight(current);
	|
	|        if(current.height() > current.data('expandedHeight') || (current.hasClass($this.options.expandedClass) && current.height() < current.data('expandedHeight')) ) {
	|          current.css('height', current.data('expandedHeight'));
	|        }
	|      });
	|    },
	|
	|    destroy: function() {
	|      var $this = this;
	|
	|      $(this.element).each(function() {
	|        var current = $(this);
	|
	|        current.removeClass('readmore-js-section ' + $this.options.collapsedClass + ' ' + $this.options.expandedClass).css({'max-height': '', 'height': 'auto'}).next('.readmore-js-toggle').remove();
	|
	|        current.removeData();
	|      });
	|    }
	|  };
	|
	|  $.fn[readmore] = function( options ) {
	|    var args = arguments;
	|    if (options === undefined || typeof options === 'object') {
	|      return this.each(function () {
	|        if ($.data(this, 'plugin_' + readmore)) {
	|          var instance = $.data(this, 'plugin_' + readmore);
	|          instance['destroy'].apply(instance);
	|        }
	|
	|        $.data(this, 'plugin_' + readmore, new Readmore( this, options ));
	|      });
	|    } else if (typeof options === 'string' && options[0] !== '_' && options !== 'init') {
	|      return this.each(function () {
	|        var instance = $.data(this, 'plugin_' + readmore);
	|        if (instance instanceof Readmore && typeof instance[options] === 'function') {
	|          instance[options].apply( instance, Array.prototype.slice.call( args, 1 ) );
	|        }
	|      });
	|    }
	|  }
	|})(jQuery);
	|</script>";

	Возврат JS1;
КонецФункции

&НаСервере
Функция ВставитьJS2()
	JS2 = "
	|
	|<script>
	|$('section').readmore({ //вызов плагина
	|speed: 250, //скорость раскрытия скрытого текста (в миллисекундах)
	|maxHeight: 260, //высота раскрытой области текста (в пикселях)
	|heightMargin: 16, //избегание ломания блоков, которые больше maxHeight (в пикселях)
	|moreLink: '<p style=""text-align:right""><a href=""#""><strong><u>Читати далі</a></u> </strong></p>', //ссылка ""Читать далее"", можно переименовать
	|lessLink: '<p style=""text-align:right""><a href=""#""><strong><u>Згорнути</a></u> </strong></p>' //ссылка ""Скрыть"", можно переименовать
	|});
	|</script>
	|";

	Возврат JS2;
КонецФункции

&НаКлиенте
Процедура ВсеНовости(Команда)
	Новости = ПолучитьНовостиНаДату("");
	ВывестиНовостиНаФорму(Новости);	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНаСайте(Команда)
	ЗапуститьПриложение("https://www.flydoc.ua/news");
КонецПроцедуры
