
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:';uk='Устаткування:'") + Символы.НПП  + Строка(Идентификатор);

	СпПорт = Элементы.Порт.СписокВыбора;
	Для Номер = 1 По 30 Цикл
		СпПорт.Добавить(Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;

	СпСкорость = Элементы.Скорость.СписокВыбора;
	СпСкорость.Добавить(600,   "600");
	СпСкорость.Добавить(1200,  "1200");
	СпСкорость.Добавить(2400,  "2400");
	СпСкорость.Добавить(4800,  "4800");
	СпСкорость.Добавить(9600,  "9600");
	СпСкорость.Добавить(14400, "14400");
	СпСкорость.Добавить(19200, "19200");

	СпТипВП = Элементы.ТипВП.СписокВыбора;
	СпТипВП.Добавить(0,  "Нет");	
	СпТипВП.Добавить(84,  "84");
	СпТипВП.Добавить(86,  "86");
	СпТипВП.Добавить(89,  "89");
	
	времПорт         = Неопределено;
	времСкорость     = Неопределено;
	времТипВП		 = Неопределено;
	времПауза		 = Неопределено;
	времМножитель	 = Неопределено;	
	
	времОписаниеПодключения = Неопределено;
	времОписаниеОтключения  = Неопределено;
	времКомандаПолучитьВес  = Неопределено;
	времКомандаОбработатьСобытие  = Неопределено;
	времОписаниеИсключение  = Неопределено;

	Параметры.ПараметрыОборудования.Свойство("Порт"        				, времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость"    				, времСкорость);
	Параметры.ПараметрыОборудования.Свойство("ТипВП"       				, времТипВП);
	Параметры.ПараметрыОборудования.Свойство("Пауза"       				, времПауза);
	Параметры.ПараметрыОборудования.Свойство("Множитель"       			, времМножитель);
	
	Параметры.ПараметрыОборудования.Свойство("ОписаниеПодключения"      		, времОписаниеПодключения);
	Параметры.ПараметрыОборудования.Свойство("ОписаниеОтключения"       		, времОписаниеОтключения);
	Параметры.ПараметрыОборудования.Свойство("КомандаПолучитьВес"       		, времКомандаПолучитьВес);
	Параметры.ПараметрыОборудования.Свойство("КомандаОбработатьСобытие" 		, времКомандаОбработатьСобытие);
	Параметры.ПараметрыОборудования.Свойство("ОписаниеИсключениеПолученияВеса"  , времОписаниеИсключение);

	Порт         = ?(времПорт         = Неопределено, 1,    времПорт);
	Скорость     = ?(времСкорость     = Неопределено, 9600, времСкорость);
	ТипВП    	 = ?(времТипВП     	  = Неопределено, 0,    времТипВП);
	Пауза        = ?(времПауза        = Неопределено, 0,    времПауза);
	Множитель    = ?(времМножитель    = Неопределено, 1,    времМножитель);
	
	ОписаниеПодключения 	 = ?(времОписаниеПодключения      = Неопределено, "",    времОписаниеПодключения);
	ОписаниеОтключения  	 = ?(времОписаниеОтключения       = Неопределено, "",    времОписаниеОтключения);
	КомандаПолучитьВес  	 = ?(времКомандаПолучитьВес       = Неопределено, "",    времКомандаПолучитьВес);
	КомандаОбработатьСобытие = ?(времКомандаОбработатьСобытие = Неопределено, "",    времКомандаОбработатьСобытие);
	ОписаниеИсключениеПолученияВеса = ?(времОписаниеИсключение = Неопределено, "",    времОписаниеИсключение);
	
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.ИНАГРО_РабочееМестоКлиента = Идентификатор.РабочееМесто);

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("Порт"         , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость"     , Скорость);
	НовыеЗначениеПараметров.Вставить("ТипВП"     	, ТипВП);
	НовыеЗначениеПараметров.Вставить("Пауза"        , Пауза);
	НовыеЗначениеПараметров.Вставить("Множитель"    , Множитель);	
	
	НовыеЗначениеПараметров.Вставить("ОписаниеПодключения"				, ОписаниеПодключения);	
	НовыеЗначениеПараметров.Вставить("ОписаниеОтключения" 				, ОписаниеОтключения);	
	НовыеЗначениеПараметров.Вставить("КомандаПолучитьВес" 				, КомандаПолучитьВес);	
	НовыеЗначениеПараметров.Вставить("КомандаОбработатьСобытие"			, КомандаОбработатьСобытие);
	НовыеЗначениеПараметров.Вставить("ОписаниеИсключениеПолученияВеса"	, ОписаниеИсключениеПолученияВеса);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.';uk='Установка драйвера завершена.'")); 
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайверИзДистрибутиваПриЗавершении(Результат, Параметры) Экспорт 
	
	Если Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.';uk='Установка драйвера завершена.'")); 
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При установке драйвера из дистрибутива произошла ошибка.';uk='При встановленні драйвера з дистрибутива сталася помилка.'")); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	ОчиститьСообщения();
	ОповещенияДрайверИзДистрибутиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзДистрибутиваПриЗавершении", ЭтотОбъект);
	ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзАрхиваПриЗавершении", ЭтотОбъект);
	ИНАГРО_МенеджерОборудованияКлиент.УстановитьДрайвер(ДрайверОборудования, ОповещенияДрайверИзДистрибутиваПриЗавершении, ОповещенияДрайверИзАрхиваПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПодключенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗаголовокОкна = Нстр("ru = 'Команды ""Подключения""'; uk = 'Команди ""Підключення""'"); 
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
	Элемент.ТекстРедактирования,
	ЭтотОбъект,
	"ОписаниеПодключения",
	ЗаголовокОкна);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПолучитьВесНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗаголовокОкна = Нстр("ru = 'Команды ""Получения веса""'; uk = 'Команди ""Отримання ваги""'"); 
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
	Элемент.ТекстРедактирования,
	ЭтотОбъект,
	"КомандаПолучитьВес",
	ЗаголовокОкна);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбработатьСобытиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ЗаголовокОкна = Нстр("ru = 'Команды ""Обработка события""'; uk = 'Команди ""Обробка події""'"); 	
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
	Элемент.ТекстРедактирования,
	ЭтотОбъект,
	"КомандаОбработатьСобытие",
	ЗаголовокОкна);
		
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОтключенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗаголовокОкна = Нстр("ru = 'Команды ""Отключения""'; uk = 'Команди ""Відключення""'"); 

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
	Элемент.ТекстРедактирования,
	ЭтотОбъект,
	"ОписаниеОтключения",
	ЗаголовокОкна);		
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеИсключениеПолученияВесаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗаголовокОкна = Нстр("ru = 'Команды ""Исключение получения веса""'; uk = 'Команди ""Вийняток отримання ваги""'"); 
		
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
	Элемент.ТекстРедактирования,
	ЭтотОбъект,
	"ОписаниеИсключениеПолученияВеса",
	ЗаголовокОкна);
	
КонецПроцедуры
	
#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#КонецОбласти