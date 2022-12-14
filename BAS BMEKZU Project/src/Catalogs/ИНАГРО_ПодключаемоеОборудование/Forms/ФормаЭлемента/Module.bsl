
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗапретИзмененияДрайвера = (Объект.Ссылка <> Справочники.ИНАГРО_ПодключаемоеОборудование.ПустаяСсылка());
	// Защита от изменения типа устройства если тип явно задан или экземпляр уже создан
	Элементы.ТипОборудования.ТолькоПросмотр = ЗапретИзмененияДрайвера;
	// Защита от изменения обработчика драйвера уже созданного экземпляра устройства
	Элементы.ДрайверОборудования.ТолькоПросмотр = ЗапретИзмененияДрайвера;
	Элементы.ФормаНастроить.Доступность = ЗначениеЗаполнено(Объект.Ссылка); 

	// Загрузка и установка списка доступных обработок
	СписокДрайверов = ПолучитьСписокДрайверов(Объект.ТипОборудования, НЕ ЗапретИзмененияДрайвера);
	Элементы.ДрайверОборудования.СписокВыбора.Очистить();
	Для каждого СтрокаСписка Из СписокДрайверов Цикл
		Элементы.ДрайверОборудования.СписокВыбора.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
	КонецЦикла;

	// Перечисление стандартных типов
	Для каждого ИмяПеречисления Из Метаданные.Перечисления.ИНАГРО_ТипыПодключаемогоОборудования.ЗначенияПеречисления Цикл
		СоответствиеТиповОборудования.Добавить(ИмяПеречисления.Синоним, ИмяПеречисления.Комментарий);
	КонецЦикла;
	
	ИНАГРО_МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриСозданииНаСервере(Объект, ЭтотОбъект, Отказ, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИНАГРО_МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПриОткрытии(Объект, ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ИНАГРО_МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПередЗакрытием(Объект, ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Элементы.ФормаНастроить.Доступность = ЗначениеЗаполнено(Объект.Ссылка); 
	
	ИНАГРО_МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриЧтенииНаСервере(ТекущийОбъект,ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Отказ И Модифицированность Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	ИНАГРО_МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПередЗаписью(Объект, ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИНАГРО_МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИНАГРО_МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ИНАГРО_МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ИНАГРО_МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПослеЗаписи(Объект, ЭтотОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ИНАГРО_МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияОбработкаПроверкиЗаполненияНаСервере(Объект, ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОборудованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Объект.ТипОборудования <> ВыбранноеЗначение Тогда
		Объект.ТипОборудования = ВыбранноеЗначение;
		Модифицированность = Истина;

		// Загрузка и установка списка доступных обработок
		СписокДрайверов = ПолучитьСписокДрайверов(Объект.ТипОборудования, НЕ ЗапретИзмененияДрайвера);
		Элементы.ДрайверОборудования.СписокВыбора.Очистить();
		Для каждого СтрокаСписка Из СписокДрайверов Цикл
			Элементы.ДрайверОборудования.СписокВыбора.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
		КонецЦикла;
		
		Объект.ДрайверОборудования = ПредопределенноеЗначение("Справочник.ИНАГРО_ДрайверыОборудования.ПустаяСсылка");
		Объект.Наименование = "";
		
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	
	ИНАГРО_МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияТипОборудованияВыбор(Объект, ЭтаФорма, ЭтотОбъект, Элемент, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДрайверОборудованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение <> Объект.ДрайверОборудования Тогда
		ОбработатьВыборОбработчика(ВыбранноеЗначение, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработатьВыборОбработчика(ВыбранныйОбработчик, СтандартнаяОбработка = Истина)

	Объект.Наименование = "'" + Строка(ВыбранныйОбработчик) + "'"
						+ ?(ПустаяСтрока(Строка(Объект.РабочееМесто)),
							"",
							" " + НСтр("ru='на';uk='на'") + " " + Строка(Объект.РабочееМесто));

КонецПроцедуры

&НаКлиенте
Процедура Настроить(Команда)
	
	ОчиститьСообщения();
	
	НастроитьПодключаемоеОборудование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьПодключаемоеОборудование()
	
	СообщениеОбОшибке = "";
	НастройкиИзменены = Ложь;
	
	Записать();
	
	Закрыть();
	
	ИНАГРО_МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(Объект.Ссылка);
	   
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокДрайверов(ТипОборудования, ТолькоДоступные)
	
	СписокДрайверов = Новый СписокЗначений();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДрайверыОборудования.Ссылка,
		|	ДрайверыОборудования.Наименование,
		|	ДрайверыОборудования.ТипОборудования
		|ИЗ
		|	Справочник.ИНАГРО_ДрайверыОборудования КАК ДрайверыОборудования
		|ГДЕ
		|	(ДрайверыОборудования.ТипОборудования = &ТипОборудования)
		|	%УСЛОВИЕ%
		|УПОРЯДОЧИТЬ ПО ДрайверыОборудования.Наименование";
		
	Если ТолькоДоступные Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УСЛОВИЕ%", "И НЕ ДрайверыОборудования.ПометкаУдаления");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УСЛОВИЕ%", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТипОборудования", ТипОборудования);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокДрайверов.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Наименование);
	КонецЦикла;
	
	Возврат СписокДрайверов;

КонецФункции

#КонецОбласти
