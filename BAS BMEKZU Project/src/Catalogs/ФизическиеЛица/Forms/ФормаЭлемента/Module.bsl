#Область ОписаниеПеременных

&НаКлиенте
Перем ОткрытыеФормы Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СотрудникиФормы.ФизическиеЛицаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВывестиДатуРегистрации(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СотрудникиКлиент.ПроверитьНеобходимостьЗаписи(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если СозданиеНового И НЕ Параметры.Ключ.Пустая() Тогда
		
		Оповестить("СозданоФизическоеЛицо", ФизическоеЛицоСсылка, ВладелецФормы);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтредактированаИстория" И ЭтаФорма.ФизическоеЛицоСсылка = Источник Тогда
		Если (Параметр.ИмяРегистра = "ГражданствоФизическихЛиц"
			ИЛИ Параметр.ИмяРегистра = "ДокументыФизическихЛиц"
			ИЛИ Параметр.ИмяРегистра = "ФИОФизическихЛиц"
			ИЛИ Параметр.ИмяРегистра = "ИНАГРО_ВоинскийУчет")
			И ЭтаФорма[Параметр.ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
			Если Параметр.ИмяРегистра = "ДокументыФизическихЛиц" Тогда
				ОбработкаОповещенияОтредактированаИсторияДокументыФизическихЛиц(ЭтаФорма, ЭтаФорма.ФизическоеЛицоСсылка, ИмяСобытия, Параметр, Источник);
				СотрудникиКлиентСервер.ОбработатьОтображениеСерияДокументаФизическогоЛица(ЭтаФорма.ДокументыФизическихЛиц.ВидДокумента, ЭтаФорма.ДокументыФизическихЛиц.Серия ,ЭтаФорма.Элементы.ДокументыФизическихЛицСерия, ЭтаФорма);
				СотрудникиКлиентСервер.ОбработатьОтображениеНомерДокументаФизическогоЛица(ЭтаФорма.ДокументыФизическихЛиц.ВидДокумента, ЭтаФорма.ДокументыФизическихЛиц.Номер ,ЭтаФорма.Элементы.ДокументыФизическихЛицНомер, ЭтаФорма);
				СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
			// ИНАГРО ++	
			ИначеЕсли Параметр.ИмяРегистра = "ИНАГРО_ВоинскийУчет" Тогда
				Если ТипЗнч(Параметр.МассивЗаписей) = Тип("ДанныеФормыСтруктураСКоллекцией") Тогда
					РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтаФорма, ЭтаФорма.ФизическоеЛицоСсылка, ИмяСобытия, Параметр, Источник);
					ОбработкаОповещенияВоинскийУчетНаСервере(ИмяСобытия, Параметр);		
				КонецЕсли;

				ПеречитатьДанныеПоВоинскомуУчету();
				НаименованиеПоМенеджеруЗаписи = "" + ЭтаФорма.ИНАГРО_ВоинскийУчет.ОтношениеКВоинскойОбязанности + 
					НСтр("ru='; Звание: ';uk='; Звання: '") + ЭтаФорма.ИНАГРО_ВоинскийУчет.Звание + 
					НСтр("ru=', ВУС: ';uk=', ВУС: '") + ЭтаФорма.ИНАГРО_ВоинскийУчет.ВУС + 
					НСтр("ru=', Годность: ';uk=', Придатність: '") + ЭтаФорма.ИНАГРО_ВоинскийУчет.Годность + 
					НСтр("ru=', Военкомат: ';uk=', Військомат: '") + ЭтаФорма.ИНАГРО_ВоинскийУчет.Военкомат +
					НСтр("ru=', ';uk=', '") + ЭтаФорма.ИНАГРО_ВоинскийУчет.ОтношениеКВоинскомуУчету +
					?(ЗначениеЗаполнено(ЭтаФорма.ИНАГРО_ВоинскийУчет.ЗабронированОрганизацией), НСтр("ru=', Забронирован за организацией ';uk=', Заброньований організацією '") + ЭтаФорма.ИНАГРО_ВоинскийУчет.ЗабронированОрганизацией ,"") + 
					?(ЭтаФорма.ИНАГРО_ВоинскийУчет.НаличиеМобпредписания, НСтр("ru=', имеет мобпредписание';uk=', має мобприпис'"),"");
				ИНАГРО_ВоинскийУчетСтрока = НаименованиеПоМенеджеруЗаписи;
			// ИНАГРО --	
			Иначе
				РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтаФорма, ЭтаФорма.ФизическоеЛицоСсылка, ИмяСобытия, Параметр, Источник);
				Если Параметр.ИмяРегистра = "ГражданствоФизическихЛиц" Тогда
					Если ЗначениеЗаполнено(ЭтаФорма.ГражданствоФизическихЛиц.Страна) Тогда
						ЭтаФорма.ГражданствоФизическихЛицЛицоБезГражданства = 0;
					Иначе
						ЭтаФорма.ГражданствоФизическихЛицЛицоБезГражданства = 1;
					КонецЕсли;
					СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма);
				ИначеЕсли Параметр.ИмяРегистра = "ФИОФизическихЛиц" Тогда
					НаименованиеПоМенеджеруЗаписи = ЭтаФорма.ФИОФизическихЛиц.Фамилия + " " + ЭтаФорма.ФИОФизическихЛиц.Имя + " " + ЭтаФорма.ФИОФизическихЛиц.Отчество;
					Если Не ПустаяСтрока(НаименованиеПоМенеджеруЗаписи) И ЭтаФорма.ФизическоеЛицо.ФИО <> НаименованиеПоМенеджеруЗаписи Тогда
						ЭтаФорма.ФизическоеЛицо.ФИО = НаименованиеПоМенеджеруЗаписи;
						СотрудникиКлиент.СформироватьНаименованиеФизическогоЛица(ЭтаФорма);
					КонецЕсли; 
					СотрудникиКлиентСервер.УстановитьВидимостьПолейФИО(ЭтаФорма);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияОтредактированаИсторияДокументыФизическихЛиц(Форма, ВедущийОбъект, ИмяСобытия, Параметр, Источник) Экспорт
	
	КоллекцииИдентичны = РедактированиеПериодическихСведенийКлиент.КоллекцииНаборовИдентичны(Форма[Параметр.ИмяРегистра + "НаборЗаписей"], Параметр.МассивЗаписей, ОбщегоНазначенияКлиентСервер.КлючиСтруктурыВСтроку(Форма[Параметр.ИмяРегистра + "Прежняя"]));
	
	Если НЕ КоллекцииИдентичны Тогда
		НаборЗаписей = Форма[Параметр.ИмяРегистра + "НаборЗаписей"];
		НаборЗаписей.Очистить();
		Для Каждого Строка Из Параметр.МассивЗаписей Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Строка);
		КонецЦикла;
		НаборЗаписей.Сортировать("Период");
		ПоследняяЗапись = Неопределено;
		Если НаборЗаписей.Количество() > 0 Тогда
			Для СмещениеИндекса = 0 По НаборЗаписей.Количество()-1 Цикл
				Запись = НаборЗаписей[НаборЗаписей.Количество() - 1 - СмещениеИндекса];
				Если Запись.ЯвляетсяДокументомУдостоверяющимЛичность Тогда
					ПоследняяЗапись = Запись;
					Прервать;
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли;
		Если ПоследняяЗапись <> Неопределено Тогда
			СтруктураЗаписи = Новый Структура();
			Для Каждого КлючЗначение Из Форма[Параметр.ИмяРегистра + "Прежняя"] Цикл
				СтруктураЗаписи.Вставить(КлючЗначение.Ключ, ПоследняяЗапись[КлючЗначение.Ключ]);
			КонецЦикла;
			Форма[Параметр.ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(СтруктураЗаписи);
		Иначе
			МенеджерЗаписи = РедактированиеПериодическихСведенийВызовСервера.СтруктураМенеджераЗаписи(Параметр.ИмяРегистра, ВедущийОбъект);
			СтруктураЗаписи = Новый Структура();
			Для Каждого КлючЗначение Из Форма[Параметр.ИмяРегистра + "Прежняя"] Цикл
				СтруктураЗаписи.Вставить(КлючЗначение.Ключ, МенеджерЗаписи[КлючЗначение.Ключ]);
			КонецЦикла;
			Форма[Параметр.ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(СтруктураЗаписи);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Форма[Параметр.ИмяРегистра], Форма[Параметр.ИмяРегистра + "Прежняя"]);
		Форма.Модифицированность = Истина;
		РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, Параметр.ИмяРегистра, ВедущийОбъект);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаОповещенияВоинскийУчетНаСервере(ИмяСобытия, Параметр)
	
		ДополнительныеСвойства = Новый Структура;
		РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(
		ЭтаФорма,
		"ИНАГРО_ВоинскийУчет",
		ФизическоеЛицоСсылка,
		,
		ДополнительныеСвойства);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	СотрудникиФормы.ФизическиеЛицаПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, ФизическоеЛицо);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СотрудникиКлиент.ФизическиеЛицаПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СотрудникиФормы.ФизическиеЛицаПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СотрудникиФормы.ФизическиеЛицаПриЗаписиНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	СотрудникиФормы.ФизическиеЛицаПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СотрудникиКлиент.ФизическиеЛицаПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	СотрудникиФормы.ФизическиеЛицаОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

//////////////////////////////////////////////////////////////////////////////////
// Сервисные процедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизлицоУНЗРПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ФизическоеЛицо.ДатаРождения) Тогда
		Если СтрНайти(ФизическоеЛицо.УНЗР, "-") = 9 Тогда
			СтрокаДР = Лев(ФизическоеЛицо.УНЗР, 8);
			Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаДР, Ложь, Ложь) Тогда
				ОписаниеТипа = Новый ОписаниеТипов("Дата");
				ДР = ОписаниеТипа.ПривестиЗначение(СтрокаДР);
				ФизическоеЛицо.ДатаРождения = ДР  
			КонецЕсли
		КонецЕсли;
	КонецЕсли	
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Редактирование данных ФизическогоЛица

&НаКлиенте
Процедура ФизлицоДРФОПриИзменении(Элемент)
	СотрудникиКлиент.ФизическиеЛицаДРФОПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоМестоРожденияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СотрудникиКлиент.ФизическиеЛицаМестоРожденияНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка, ФизическоеЛицо.МестоРождения);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Редактирование ФИО

&НаКлиенте
Процедура ФИОПриИзменении(Элемент)
	
	СотрудникиКлиент.ПриИзмененииФИОФизическогоЛица(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникИзменилФИОНажатие(Элемент)
	СотрудникиКлиент.ФизическоеЛицоИзменилФИОНажатие(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура УточнениеНаименованияПриИзменении(Элемент)
	 СотрудникиКлиент.СформироватьНаименованиеФизическогоЛица(ЭтаФорма);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Редактирования данных о составе семьи
&НаКлиенте
Процедура СоставСемьиФизЛицоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СоставСемьи.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.ФизЛицо) Тогда
		ТекущиеДанные.ГодРождения = ГодРождения(ТекущиеДанные.ФизЛицо);
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Функция ГодРождения(ФизЛицо)
	
	Возврат ?(ЗначениеЗаполнено(ФизЛицо.ДатаРождения),Год(ФизЛицо.ДатаРождения),0); 	
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////////
// Редактирование гражданства

&НаКлиенте
Процедура ГражданствоФизическихЛицЛицоБезГражданстваПриИзменении(Элемент)
	
	Если ГражданствоФизическихЛицЛицоБезГражданства = 0 Тогда
		
		Если НЕ ЗначениеЗаполнено(ГражданствоФизическихЛиц.Страна)
			И ЗначениеЗаполнено(ГражданствоФизическихЛицПрежняя.Страна) Тогда
		КонецЕсли;
		
		ГражданствоФизическихЛиц.Страна = ГражданствоФизическихЛицПрежняя.Страна;
		Если НЕ ЗначениеЗаполнено(ГражданствоФизическихЛиц.Страна) Тогда
			ГражданствоФизическихЛиц.Страна = ПредопределенноеЗначение("Справочник.СтраныМира.Украина");
		КонецЕсли; 
		
	Иначе
		
		ГражданствоФизическихЛиц.Страна = ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка");
		
	КонецЕсли;
	
	СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицСтранаПриИзменении(Элемент)
	
	СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицПериодПриИзменении(Элемент)
	
	ГражданствоФизическихЛиц.Период = ГражданствоФизическихЛицПериод;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Редактирование удостоверения личности

&НаКлиенте
Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Элемент)
	СотрудникиКлиент.ДокументыФизическихЛицВидДокументаПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицСерияПриИзменении(Элемент)
	СотрудникиКлиент.ДокументыФизическихЛицСерияПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицНомерПриИзменении(Элемент)
	СотрудникиКлиент.ДокументыФизическихЛицНомерПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СотрудникиКлиент.ДокументыФизическихЛицВидДокументаНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицДатаВыдачиПриИзменении(Элемент)
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицСрокДействияПриИзменении(Элемент)
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицКемВыданПриИзменении(Элемент)
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицКодПодразделенияПриИзменении(Элемент)
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Работа с Сотрудником

&НаКлиенте
Процедура ДополнитьПредставлениеПриИзменении(Элемент)
	СотрудникиКлиент.ДополнитьПредставлениеФизическогоЛицаПриИзменении(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсеДокументыЭтогоЧеловека(Команда)
	
	СотрудникиКлиент.ОткрытьСписокВсехДокументовФизическогоЛица(ЭтаФорма, ФизическоеЛицоСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ГражданствоФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ДокументыФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ФИОФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ФИОФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ВоинскийУчетИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ИНАГРО_ВоинскийУчет", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВоинскийУчетСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ИНАГРО_ВоинскийУчетНаборЗаписейПрочитан = Истина;	
	Ключ = ПолучитьКлючВоинскийУчет();
	
	Если Ключ = Неопределено Тогда
		ФормаЗаписи = ПолучитьФорму("РегистрСведений.ИНАГРО_ВоинскийУчет.ФормаЗаписи");
		ФормаЗаписи.Открыть();
		ФормаЗаписи.Запись.Период = ТекущаяДата();
		ФормаЗаписи.Запись.ФизЛицо = ФизическоеЛицоСсылка;
		ФормаЗаписи.ОбъектВладелец = ФизическоеЛицоСсылка;
	Иначе
		Структура = Новый Структура("Ключ", Ключ);
		ФормаЗаписи = ПолучитьФорму("РегистрСведений.ИНАГРО_ВоинскийУчет.ФормаЗаписи", Структура);
		ФормаЗаписи.Открыть();
		ФормаЗаписи.ОбъектВладелец = ФизическоеЛицоСсылка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Функция ПолучитьКлючВоинскийУчет()
	ДанныеВоинскогоУчета = РегистрыСведений.ИНАГРО_ВоинскийУчет;
	ТекущиеДанныеВУ = ДанныеВоинскогоУчета.СрезПоследних(ТекущаяДата(), Новый Структура("ФизЛицо", ФизическоеЛицоСсылка));
	
	Если ТекущиеДанныеВУ.Количество() > 0 Тогда 
		Возврат РегистрыСведений.ИНАГРО_ВоинскийУчет.СоздатьКлючЗаписи(Новый Структура("Период, ФизЛицо", ТекущиеДанныеВУ[0].Период, ФизическоеЛицоСсылка));
	Иначе
		Возврат Неопределено;
	КонецЕсли;
		
КонецФункции
	
&НаСервере
Процедура ПеречитатьДанныеПоВоинскомуУчету();
	СотрудникиФормы.ПрочитатьДанныеСвязанныеСФизлицом(ЭтаФорма, ДоступенПросмотрДанныхФизическихЛиц, Неопределено, Ложь);
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации()
	СотрудникиФормы.ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ВывестиДатуРегистрации(Форма)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
	
	НайденнаяСтрока = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор)[0];
	ИмяРеквизита = НайденнаяСтрока.ИмяРеквизита;
	АдресРегистрации = Форма.Элементы[ИмяРеквизита];
	
	НоваяГруппа = Форма.Элементы.Добавить("ГруппаДатыРегистрации", Тип("ГруппаФормы"));
	НоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НоваяГруппа.ОтображатьЗаголовок = Ложь;
	НоваяГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
	НоваяГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	
	Форма.Элементы.Переместить(НоваяГруппа, АдресРегистрации.Родитель, АдресРегистрации);
	
	Форма.Элементы.Переместить(АдресРегистрации, НоваяГруппа);
	
	ПоложениеЗаголовкаВерх = ВРег(Форма.ПараметрыКонтактнойИнформации.ГруппаКонтактнаяИнформация.ПоложениеЗаголовка) = ВРег("ПоложениеЗаголовкаЭлементаФормы.Верх");
	ПоложениеЗаголовкаКонтактнойИнформации = ?(ПоложениеЗаголовкаВерх, ПоложениеЗаголовкаЭлементаФормы.Верх, ПоложениеЗаголовкаЭлементаФормы.Лево);
	
	Элемент = Форма.Элементы.Добавить("ДатаРегистрации", Тип("ПолеФормы"), НоваяГруппа);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "ФизическоеЛицо.ДатаРегистрации";
	Элемент.РастягиватьПоГоризонтали = Ложь;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаКонтактнойИнформации;
	Элемент.Ширина = 9;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаКонтактнойИнформации;
	
КонецПроцедуры

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(
		ЭтотОбъект, Элемент, , СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.Очистка(
		ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(
		ЭтотОбъект, Команда.Имя);
	
КонецПроцедуры

&НаСервере
Функция Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	
	РезультатОбновления = УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, ФизическоеЛицо, Результат);
	ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации();
	
	Возврат РезультатОбновления;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов() Экспорт 
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, ФизическоеЛицо);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ФизическоеЛицо);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ФизическоеЛицо);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ФизическоеЛицо);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, ФизическоеЛицо, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, ФизическоеЛицо);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#Область ПроцедурыПодсистемыКонтактнаяИнформация
 
&НаКлиенте
Процедура Подключаемый_ПояснениеНажатие(Элемент, СтандартнаяОбработка = Ложь)
	СотрудникиКлиент.ПояснениеНажатие(Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Функция ОбновитьКонтактнуюИнформацию(Результат = Неопределено) Экспорт
	
	Возврат УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтаФорма, ФизическоеЛицо, Результат);
	
КонецФункции
	
#КонецОбласти

#КонецОбласти

#Область ПроцедурыПодсистемыСвойств
	
#КонецОбласти 
	
#Область ОбработчикиКомандФормы
 
// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, ФизическоеЛицо);
	
КонецПроцедуры

#КонецОбласти
