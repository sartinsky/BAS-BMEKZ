////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "СотрудникСсылка,ТекущаяОрганизация");
	
	ЦветСтиляЦветТекстаПоля = ЦветаСтиля.ЦветТекстаПоля;
	ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СотрудникСсылка, "ФизическоеЛицо");
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить("Организация", ТекущаяОрганизация);
	СтруктураВедущихОбъектов.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФормеПоСтруктуре(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам", СтруктураВедущихОбъектов);
	
	ПрочитатьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СотрудникиКлиент.ЗарегистрироватьОткрытиеФормы(ЭтаФорма, "ВыплатаЗарплаты");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СотрудникиКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамОбработкаОповещения(ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить("Организация", ТекущаяОрганизация);
	СтруктураВедущихОбъектов.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	
	РедактированиеПериодическихСведений.ПроверитьЗаписьВФормеПоСтруктуре(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам", СтруктураВедущихОбъектов, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НомерЛицевогоСчетаПриИзменении(Элемент)
	
	Если ПустаяСтрока(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета) Тогда
		ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект = ПредопределенноеЗначение("Справочник.ЗарплатныеПроекты.ПустаяСсылка");
	ИначеЕсли Не ЗначениеЗаполнено(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект) Тогда
		ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект = ЗарплатныйПроектПоОрганизации(ТекущаяОрганизация);
	КонецЕсли;
	
	УстановитьДоступностьЗарплатногоПроектаПериода(Элементы, ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект);
	
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатныйПроектПриИзменении(Элемент)
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоЛСНадписьНажатие(Элемент, СтандартнаяОбработка)
	
	СотрудникиКлиент.ПояснениеНажатие(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

///////////////////////////////////////////////////////
// редактирование месяца строкой

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период", "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПериодСтрокой", Модифицированность);
	
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма,
		ЭтаФорма,
		"ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период",
		"ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПериодСтрокой",
		Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период", "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПериодСтрокой", Направление, Модифицированность);
	
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Перечитать(Команда)
	
	ПрочитатьДанные();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействующийЛицевойСчет(Команда)
	
	ЛицевыеСчетаСотрудника = СписокЛицевыхСчетовСотрудника(ТекущаяОрганизация, ФизическоеЛицо, 
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект, ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя);
			
	ДополнительныеПараметры = Новый Структура("ЛицевыеСчетаСотрудника", ЛицевыеСчетаСотрудника);		
			
	Оповещение = Новый ОписаниеОповещения("ДействующийЛицевойСчетПродолжение", ЭтотОбъект, ДополнительныеПараметры); 
	ЛицевыеСчетаСотрудника.ПоказатьВыборЭлемента(Оповещение, НСтр("ru='Выберите действующий лицевой счет сотрудника.';uk='Виберіть діючий особовий рахунок співрбітника.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ДействующийЛицевойСчетПродолжение(ВыбранныйЭлементСписка, ДополнительныеПараметры) Экспорт 

	Если ВыбранныйЭлементСписка = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЛицевыеСчетаСотрудника = ДополнительныеПараметры.ЛицевыеСчетаСотрудника;
	
	СтруктураЛицевогоСчета = ВыбранныйЭлементСписка.Значение;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЛицевыеСчетаСотрудника", ЛицевыеСчетаСотрудника);
	ДополнительныеПараметры.Вставить("СтруктураЛицевогоСчета", СтруктураЛицевогоСчета);
	
	Оповещение = Новый ОписаниеОповещения("ДействующийЛицевойСчетЗавершение", ЭтотОбъект, ДополнительныеПараметры); 
	
	ТекстВопроса = НСтр("ru='Для перечисления зарплаты сотруднику будет использоваться счет в банке %1.
|Номера лицевых счетов в других банках будут удалены. Продолжить?';uk='Для перерахування зарплати співробітнику буде використовуватися рахунок у банку %1.
|Номери особових рахунків в інших банках будуть вилучені. Продовжити?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, СтруктураЛицевогоСчета.Банк);
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействующийЛицевойСчетЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЛицевыеСчетаСотрудника = ДополнительныеПараметры.ЛицевыеСчетаСотрудника;
	СтруктураЛицевогоСчета = ДополнительныеПараметры.СтруктураЛицевогоСчета;
	
	УдалитьНеДействующиеЛицевыеСчетаСервере(ЛицевыеСчетаСотрудника, СтруктураЛицевогоСчета, ТекущаяОрганизация, ФизическоеЛицо);
	
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамКоличество = 1;
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект = СтруктураЛицевогоСчета.ЗарплатныйПроект;
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета = СтруктураЛицевогоСчета.НомерЛицевогоСчета;
	
	УстановитьСтраницуБанкСчетИнфо(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамИстория(Команда)
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить("Организация", ТекущаяОрганизация);
	СтруктураВедущихОбъектов.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	
	РедактированиеПериодическихСведенийКлиент.ОткрытьИсториюПоСтруктуре("ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам", СтруктураВедущихОбъектов, ЭтаФорма, ТолькоПросмотр);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Функция ЗарплатныйПроектПоОрганизации(ТекущаяОрганизация)
	Возврат ЗарплатныеПроекты.ЗарплатныйПроектПоОрганизации(ТекущаяОрганизация);
КонецФункции

&НаСервере
Процедура ПрочитатьДанные()
	
	ПрочитатьЛицевыеСчетаСотрудника();
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период", "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПериодСтрокой");
	
	Если НЕ ПустаяСтрока(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета) Тогда
		СтруктураПояснения = СтруктураПоясненияКНомеруЛицевогоСчета(
			ФизическоеЛицо,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя);
		
		ФизическоеЛицоЛСВведенДокументом = СтруктураПояснения.ВведенДокументом;
		
		ЗарплатныеПроектыКлиентСервер.УстановитьПояснениеКНомеруЛицевогоСчета(ЭтаФорма, СтруктураПояснения);
	Иначе
		ЗарплатныеПроектыКлиентСервер.УстановитьПояснениеКНомеруЛицевогоСчета(ЭтаФорма);
	КонецЕсли;
	
	УстановитьДоступностьБанкСчет();
	УстановитьДоступностьЗарплатногоПроектаПериода(Элементы, ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект);
	УстановитьСтраницуБанкСчетИнфо(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные(Отказ) Экспорт
	
	ТекстКнопкиДа = НСтр("ru='Изменился номер лицевого счета';uk='Змінився номер особового рахунку'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='При редактировании Вы изменили номер лицевого счета или зарплатный проект. 
|Если Вы исправили прежнюю запись лицевого счета (она была ошибочной), нажмите ""Исправлена ошибка"".
|Если у лицевого счета изменился номер или зарплатный проект с %1, нажмите ""%2""';uk='При редагуванні Ви змінили номер особового рахунку або зарплатний проект. 
|Якщо Ви виправили колишній запис особового рахунку (він був помилковим), натисніть ""Виправлена помилка"".
|Якщо у особового рахунку змінився номер або зарплатний проект з %1, натисніть ""%2""'"), 
		Формат(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период, "ДФ='д ММММ гггг ""г""'"),
		ТекстКнопкиДа);
	
	РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам", ТекстВопроса, ТекстКнопкиДа, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьДанныеНаСервере(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеНаСервере(Отказ)
	
	Если ПроверитьЗаполнение() Тогда
		
		ЗаписатьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам();
		
		Модифицированность = Ложь;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиенте(ЗакрытьФорму = Истина) Экспорт  

	СохранитьДанные(Ложь);
	
	Если Открыта() Тогда
		
		Модифицированность = Ложь;
		Если ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли; 
		
	КонецЕсли; 

	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокЛицевыхСчетовСотрудника(Организация, ФизическоеЛицо, ЗарплатныйПроект, НомерСчета, ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период КАК Период,
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект КАК ЗарплатныйПроект,
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Банк КАК Банк,
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета КАК НомерЛицевогоСчета
	|ИЗ
	|	РегистрСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СрезПоследних(, ) КАК ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам
	|ГДЕ
	|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация = &Организация
	|	И ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо = &ФизическоеЛицо";
	
	ЛицевыеСчетаСотрудника = Запрос.Выполнить().Выбрать();
	
	СписокЛицевыхСчетов = Новый СписокЗначений;
	
	Пока ЛицевыеСчетаСотрудника.Следующий() Цикл
		
		СтруктураЛицевогоСчета = Новый Структура;
		СтруктураЛицевогоСчета.Вставить("Период", ЛицевыеСчетаСотрудника.Период);
		СтруктураЛицевогоСчета.Вставить("НомерЛицевогоСчета", ЛицевыеСчетаСотрудника.НомерЛицевогоСчета);
		СтруктураЛицевогоСчета.Вставить("ЗарплатныйПроект", ЛицевыеСчетаСотрудника.ЗарплатныйПроект);
		СтруктураЛицевогоСчета.Вставить("Банк", ЛицевыеСчетаСотрудника.Банк);
		
		СписокЛицевыхСчетов.Добавить(СтруктураЛицевогоСчета,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 %2';uk='%1 %2'"),
					ЛицевыеСчетаСотрудника.НомерЛицевогоСчета,
					ЛицевыеСчетаСотрудника.Банк));
		
	КонецЦикла;
	
	// Если изменили лицевой счет на форме, то заменим его в списке
	Для каждого ЭлементСписка Из СписокЛицевыхСчетов Цикл
		ЛицевойСчетСотрудника = ЭлементСписка.Значение;
		Если ЛицевойСчетСотрудника.Период = ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя.Период
			И ЛицевойСчетСотрудника.НомерЛицевогоСчета = ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя.НомерЛицевогоСчета
			И ЛицевойСчетСотрудника.ЗарплатныйПроект = ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя.ЗарплатныйПроект Тогда
			
			ЛицевойСчетСотрудника.НомерЛицевогоСчета = НомерСчета;
			ЛицевойСчетСотрудника.ЗарплатныйПроект = ЗарплатныйПроект;
			ЭлементСписка.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 %2';uk='%1 %2'"),
										НомерСчета,
										?(ЗначениеЗаполнено(ЗарплатныйПроект),
													ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗарплатныйПроект, "Банк"),
													ЛицевойСчетСотрудника.Банк));
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокЛицевыхСчетов;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьНеДействующиеЛицевыеСчетаСервере(СписокЛицевыхСчетовСотрудника, СтруктураВыбранногоЭлемента, Организация, ФизическоеЛицо)
	
	Для каждого ЭлементСписка Из СписокЛицевыхСчетовСотрудника Цикл
		
		СтруктураЛицевогоСчета = ЭлементСписка.Значение;
		Если СтруктураЛицевогоСчета.Банк = СтруктураВыбранногоЭлемента.Банк
			И СтруктураЛицевогоСчета.НомерЛицевогоСчета = СтруктураВыбранногоЭлемента.НомерЛицевогоСчета
			И СтруктураЛицевогоСчета.ЗарплатныйПроект = СтруктураВыбранногоЭлемента.ЗарплатныйПроект Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ЗаписьНабора = РегистрыСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СоздатьМенеджерЗаписи();
		ЗаписьНабора.Организация = Организация;
		ЗаписьНабора.ФизическоеЛицо = ФизическоеЛицо;
		ЗаписьНабора.Банк = СтруктураЛицевогоСчета.Банк;
		ЗаписьНабора.Прочитать();
		
		ЗаписьНабора.Удалить();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСтраницуБанкСчетИнфо(Форма) Экспорт
	
	Если Форма.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамКоличество > 1 Тогда
		
		Форма.Элементы.ЛицевойСчетСтраницы.ТекущаяСтраница = Форма.Элементы.ЛицевойСчетСтраницаДействующий;
		Форма.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамДействующийИнфо = НСтр("ru='В настоящий момент зарегистрированы лицевые счета и в других банках.
|Для корректного заполнения документов следует использовать единственный лицевой счет.';uk='У даний момент зареєстровані особові рахунки і в інших банках.
|Для коректного заповнення документів слід використовувати єдиний особовий рахунок.'");
		Форма.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамДействующийКартинка = БиблиотекаКартинок.Предупреждение;
		
	Иначе
		
		Форма.Элементы.ЛицевойСчетСтраницы.ТекущаяСтраница = Форма.Элементы.ЛицевойСчетСтраницаИнфо;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЗарплатногоПроектаПериода(Элементы, НомерЛицевогоСчета, ЗарплатныйПроект)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамЗарплатныйПроект",
		"Доступность",
		Не ПустаяСтрока(НомерЛицевогоСчета));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПериодСтрокой",
		"Доступность",
		Не ПустаяСтрока(НомерЛицевогоСчета));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьБанкСчет() Экспорт
	
	ОрганизацияЗаполнена = ЗначениеЗаполнено(ТекущаяОрганизация);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамЗарплатныйПроект",
		"Доступность",
		ОрганизацияЗаполнена);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНомерЛицевогоСчета",
		"Доступность",
		ОрганизацияЗаполнена);
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамИнфо = ?(ОрганизацияЗаполнена, "", СотрудникиФормыВнутренний.БанковскийСчетИнформацияОПричинахНедоступности());
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамКартинка = ?(ОрганизацияЗаполнена, Новый Картинка, БиблиотекаКартинок.Информация);
	
	Если ПустаяСтрока(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета)
		И НЕ ЗначениеЗаполнено(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект) Тогда
		ОтметкаНезаполненного = Ложь
	Иначе
		ОтметкаНезаполненного = Истина;
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНомерЛицевогоСчета",
		"АвтоОтметкаНезаполненного",
		ОтметкаНезаполненного);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамЗарплатныйПроект",
		"АвтоОтметкаНезаполненного",
		ОтметкаНезаполненного);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьЛицевыеСчетаСотрудника()
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить("Организация", ТекущаяОрганизация);
	СтруктураВедущихОбъектов.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФормеПоСтруктуре(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам", СтруктураВедущихОбъектов);
	
	Если ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период = Дата(1,1,1) Тогда
		ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	МассивСотрудников = Новый Массив;
	МассивСотрудников.Добавить(СотрудникСсылка);
	ЛицевыеСчетаФизическогоЛица = ЗарплатныеПроекты.ЛицевыеСчетаСотрудников(МассивСотрудников, Истина, ТекущаяОрганизация);
	
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамКоличество = ЛицевыеСчетаФизическогоЛица.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам()
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить("Организация", ТекущаяОрганизация);
	СтруктураВедущихОбъектов.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	
	РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФормеПоСтруктуре(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам", СтруктураВедущихОбъектов);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьНовуюЗаписьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам()
	
	Если Не ЭтаФорма["ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНаборЗаписейПрочитан"] Тогда
		
		СтруктураВедущихОбъектов = Новый Структура();
		СтруктураВедущихОбъектов.Вставить("Организация", ТекущаяОрганизация);
		СтруктураВедущихОбъектов.Вставить("ФизическоеЛицо", ФизическоеЛицо);
		ПрочитатьНаборЗаписейПериодическихСведенийПоСтруктуре("ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам", СтруктураВедущихОбъектов);
		
	КонецЕсли;
	
	НоваяЗапись = ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам);
	Если ЗначениеЗаполнено(НоваяЗапись.Документ) Тогда
		НоваяЗапись.Документ = Неопределено;
	КонецЕсли;
	НовыйПериод = НачалоМесяца(ТекущаяДата());
	Если ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНаборЗаписей.Количество() > 1 Тогда
		ПоследнийПериод = ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНаборЗаписей.Получить(
				ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНаборЗаписей.Количество() - 2).Период;
	Иначе
		ПоследнийПериод = '00010101000000';
	КонецЕсли;
	Если НовыйПериод <= ПоследнийПериод Тогда
		НовыйПериод = КонецМесяца(ПоследнийПериод) + 1;
	КонецЕсли;
	НоваяЗапись.Период = НовыйПериод;
	
	ЗаполнитьЗначенияСвойств(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам, НоваяЗапись);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период", "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПериодСтрокой");
	
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНоваяЗапись = Истина;
	
	СтруктураЗаписиСтрокой = "";
	ПрежняяЗапись = Новый Структура;
	НужнаЗапятая = Ложь;
	Для Каждого КлючЗначение Из ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя Цикл
		Если НужнаЗапятая Тогда
			СтруктураЗаписиСтрокой = СтруктураЗаписиСтрокой + ",";
		КонецЕсли;
		СтруктураЗаписиСтрокой = СтруктураЗаписиСтрокой + КлючЗначение.Ключ;
		НужнаЗапятая = Истина;
		ПрежняяЗапись.Вставить(КлючЗначение.Ключ);
	КонецЦикла;
	ЗаполнитьЗначенияСвойств(ПрежняяЗапись, НоваяЗапись);
	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя = Новый ФиксированнаяСтруктура(ПрежняяЗапись);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПриИзменении()
	
	// Значения введенные документом не изменяем
	Если ЗначениеЗаполнено(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя.Документ) Тогда
		СоздатьНовуюЗаписьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам();
	КонецЕсли;
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить("Организация", ТекущаяОрганизация);
	СтруктураВедущихОбъектов.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВводаПоСтруктуре(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам", СтруктураВедущихОбъектов);
	
	Если НЕ ПустаяСтрока(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета) Тогда
		СтруктураПояснения = СтруктураПоясненияКНомеруЛицевогоСчета(
			ФизическоеЛицо,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя);
		
		ЗарплатныеПроектыКлиентСервер.УстановитьПояснениеКНомеруЛицевогоСчета(ЭтаФорма, СтруктураПояснения);
	Иначе
		ЗарплатныеПроектыКлиентСервер.УстановитьПояснениеКНомеруЛицевогоСчета(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СтруктураВедущихОбъектов = Новый Структура();
	СтруктураВедущихОбъектов.Вставить("Организация", ТекущаяОрганизация);
	СтруктураВедущихОбъектов.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	
	РедактированиеПериодическихСведенийКлиент.ОбработкаОповещенияПоСтруктуре(ЭтаФорма, СтруктураВедущихОбъектов, ИмяСобытия, Параметр, Источник);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период", "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПериодСтрокой");
	
	Если НЕ ПустаяСтрока(ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета) Тогда
		СтруктураПояснения = СтруктураПоясненияКНомеруЛицевогоСчета(
			ФизическоеЛицо,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя);
		
		ЗарплатныеПроектыКлиентСервер.УстановитьПояснениеКНомеруЛицевогоСчета(ЭтаФорма, СтруктураПояснения);
	Иначе
		ЗарплатныеПроектыКлиентСервер.УстановитьПояснениеКНомеруЛицевогоСчета(ЭтаФорма);
	КонецЕсли;
	
	УстановитьДоступностьЗарплатногоПроектаПериода(Элементы, ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета,
			ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтруктураПоясненияКНомеруЛицевогоСчета(ФизическоеЛицо, ЗарплатныйПроект, НомерЛицевогоСчета, Знач ЛицевыеСчета, ЛицевыеСчетаПрежняя)
	
	СтруктураПояснения = ЗарплатныеПроекты.СтруктураПоясненияКНомеруЛицевогоСчета(
			ФизическоеЛицо,
			ЗарплатныйПроект,
			НомерЛицевогоСчета,
			ЛицевыеСчета,
			ЛицевыеСчетаПрежняя);
	
	Возврат СтруктураПояснения;
	
КонецФункции

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведенийПоСтруктуре(ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписейПоСтруктуре(ЭтаФорма, ИмяРегистра, СтруктураВедущихОбъектов);
	
КонецПроцедуры



