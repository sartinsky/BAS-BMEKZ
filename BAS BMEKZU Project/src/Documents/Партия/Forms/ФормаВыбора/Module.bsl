////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМЫ

&НаСервереБезКонтекста
Процедура ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, ТаблицаПриемник)

	Для Каждого СтрокаТаблицыИсточника Из ТаблицаИсточник Цикл

		СтрокаТаблицыПриемника = ТаблицаПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыПриемника, СтрокаТаблицыИсточника);

	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОграничениеСпискаДокументовПоТипу(Результат, ТипыДокументов)

	СтрокиКУдалению = Новый Массив();

	Для Каждого СтрокаВыборки Из Результат Цикл

		Если (НЕ ТипыДокументов.СодержитТип(ТипЗнч(СтрокаВыборки.Документ))) ИЛИ НЕ ЗначениеЗаполнено(СтрокаВыборки.Документ) Тогда
			СтрокиКУдалению.Добавить(СтрокаВыборки);
		КонецЕсли;

	КонецЦикла;

	Для Каждого СтрокаВыборки Из СтрокиКУдалению Цикл
		Результат.Удалить(СтрокаВыборки);
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеСпискаПоРеквизитам(СтруктураОтбора)
	
	НачПериода      = СтруктураОтбора["НачПериода"];
	КонПериода      = СтруктураОтбора["КонПериода"];
	Организация     = СтруктураОтбора["Организация"];
	ОграничениеТипа = СтруктураОтбора["ТипыДокументов"];
	
	Запрос = Новый Запрос;

	// Определим типы документов, которые могут являться партиями и по ним по всем сформируем текст запроса
	ТипыСубконтоПартии = ОграничениеТипа.Типы();

	ОсновноеТелоЗапроса = "";

	Для Каждого Тип Из ТипыСубконтоПартии Цикл

		ИдентификаторДокумента = Метаданные.НайтиПоТипу(Тип).Имя;

		Если ОсновноеТелоЗапроса <> "" Тогда

			ОсновноеТелоЗапроса = ОсновноеТелоЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|";
			
		КонецЕсли;

		ОсновноеТелоЗапроса = ОсновноеТелоЗапроса + 
		"ВЫБРАТЬ
		|	Партия.Ссылка Как Партия
		|" + ?(ОсновноеТелоЗапроса = "", "ПОМЕСТИТЬ СписокПартий", "") + "
		|ИЗ
		|	Документ." + ИдентификаторДокумента + " КАК Партия
		|ГДЕ
		|	Партия.Дата МЕЖДУ &НачПериода И &КонПериода И" + ?(ЗначениеЗаполнено(Организация),"
		|	Партия.Организация = &Организация И", "") + "
		|	НЕ Партия.ПометкаУдаления
		|";

	КонецЦикла;

	КонецЗапроса = 
	";
	|
	|ВЫБРАТЬ
	|	СписокПартий.Партия КАК Документ
	|ИЗ
	|	СписокПартий
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокПартий.Партия
	|АВТОУПОРЯДОЧИВАНИЕ";

	Запрос.Текст = ОсновноеТелоЗапроса + КонецЗапроса;
	Запрос.УстановитьПараметр("НачПериода",  НачалоДня(НачПериода));
	Запрос.УстановитьПараметр("КонПериода",  КонПериода);
	Запрос.УстановитьПараметр("Организация", Организация);

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеСпискаПоОборотам(СтруктураОтбора)
	
	НачПериода      = СтруктураОтбора["НачПериода"];
	КонПериода      = СтруктураОтбора["КонПериода"];
	Организация     = СтруктураОтбора["Организация"];
	Номенклатура    = СтруктураОтбора["Номенклатура"];
	Склад           = СтруктураОтбора["Склад"];
	СчетУчета       = СтруктураОтбора["СчетУчета"];
	ОграничениеТипа = СтруктураОтбора["ТипыДокументов"];
	
	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачПериода",   НачалоДня(НачПериода));
	Запрос.УстановитьПараметр("КонПериода",   КонПериода);
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);

	УсловиеВТекстеЗапроса = ?(НЕ ЗначениеЗаполнено(Организация), "Субконто1 = &Номенклатура", "Субконто1 = &Номенклатура И Организация = &Организация");

	// Если указан счет учета, то необходимо отобрать партии по счету учета
	Если ЗначениеЗаполнено(СчетУчета) Тогда
		Запрос.УстановитьПараметр("Счет", СчетУчета);
		УсловиеВыбораСчетаВТекстеЗапроса = "Счет В (&Счет)";
	Иначе
		УсловиеВыбораСчетаВТекстеЗапроса = "";
	КонецЕсли;

	// Если указан склад, то необходимо отобрать партии по складу
	Если ЗначениеЗаполнено(Склад) Тогда
		Запрос.УстановитьПараметр("Склад", Склад);
		Видысубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
		УсловиеВТекстеЗапроса = УсловиеВТекстеЗапроса + " И Субконто3 = &Склад";
	КонецЕсли;

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОсновнойОбороты.Субконто2.Ссылка КАК Документ
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачПериода, &КонПериода, , " + УсловиеВыбораСчетаВТекстеЗапроса + ", &ВидыСубконто, " + УсловиеВТекстеЗапроса + ", , ) КАК ОсновнойОбороты";
	Результат = Запрос.Выполнить().Выгрузить();

	ОграничениеСпискаДокументовПоТипу(Результат, ОграничениеТипа);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеСпискаПоОстаткам(СтруктураОтбора)

	НачПериода      = СтруктураОтбора["НачПериода"];
	КонПериода      = СтруктураОтбора["КонПериода"];
	Организация     = СтруктураОтбора["Организация"];
	Номенклатура    = СтруктураОтбора["Номенклатура"];
	Склад           = СтруктураОтбора["Склад"];
	СчетУчета       = СтруктураОтбора["СчетУчета"];
	ОграничениеТипа = СтруктураОтбора["ТипыДокументов"];
	
	ВидыСубконто = Новый Массив;
	Видысубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Видысубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонПериода",   КонПериода);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);

	УсловиеВТекстеЗапроса = ?(НЕ ЗначениеЗаполнено(Организация), "Субконто1 = &Номенклатура", "Субконто1 = &Номенклатура И Организация = &Организация");

	// Если указан склад, то необходимо отобрать партии по складу
	Если ЗначениеЗаполнено(СчетУчета) Тогда
		Запрос.УстановитьПараметр("Счет", БухгалтерскийУчетВызовСервераПовтИсп.СчетаВИерархии(СчетУчета));
		УсловиеВыбораСчетаВТекстеЗапроса = "Счет В (&Счет)";
	Иначе 
		УсловиеВыбораСчетаВТекстеЗапроса = "";
	КонецЕсли;

	// Если указан склад, то необходимо отобрать партии по складу
	Если ЗначениеЗаполнено(Склад) Тогда
		Запрос.УстановитьПараметр("Склад", Склад);
		Видысубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
		УсловиеВТекстеЗапроса = УсловиеВТекстеЗапроса + " И Субконто3 = &Склад";
	КонецЕсли;

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОсновнойОстатки.Субконто2 КАК Документ,
	|	ОсновнойОстатки.КоличествоОстаток КАК Остаток,
	|	ОсновнойОстатки.СуммаОстаток КАК Сумма,
	|	ВЫБОР КОГДА	ОсновнойОстатки.КоличествоОстаток > 0
	|	ТОГДА ОсновнойОстатки.СуммаОстаток / ОсновнойОстатки.КоличествоОстаток
	|	ИНАЧЕ 0
	|	КОНЕЦ КАК Цена
	|ИЗ  
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&КонПериода, "+ УсловиеВыбораСчетаВТекстеЗапроса + ", &ВидыСубконто, " + УсловиеВТекстеЗапроса + ") КАК ОсновнойОстатки";
	
	Результат = Запрос.Выполнить().Выгрузить();
	ОграничениеСпискаДокументовПоТипу(Результат, ОграничениеТипа);
	
	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.СчетУчета.Доступность = НЕ Форма.РежимОтбораДокументов = Форма.РежимыОтбораДокументов.ПоРеквизитам;
	Форма.Элементы.Склад.Доступность     = Форма.Склад <> Неопределено;
	Если Форма.НаСчетеВедетсяУчетПоСкладам Тогда
		Форма.Элементы.Склад.Доступность = Истина;
	КонецЕсли;
	
	ОтборПоОстаткам = Форма.РежимОтбораДокументов = Форма.РежимыОтбораДокументов.ПоОстаткам;
	
	Форма.Элементы.СписокОстаток.Видимость = ОтборПоОстаткам;
	Форма.Элементы.СписокЦена.Видимость    = ОтборПоОстаткам;
	Форма.Элементы.СписокСумма.Видимость   = ОтборПоОстаткам;
	
КонецПроцедуры
	
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура РежимОтбораПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимОтбораОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	НаСчетеВедетсяУчетПоСкладам = БухгалтерскийУчетВызовСервераПовтИсп.ВедетсяУчетПоСкладам(СчетУчета);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСервер()
	
	Список.Очистить();

	Если РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоРеквизитам Тогда
		
		СтруктураОтбора = Новый Структура("НачПериода, КонПериода, Организация, ТипыДокументов",
		                                  НачалоПериода,
		                                  КонецПериода,
		                                  Организация,
		                                  ТипыДокументов);
	
		ТаблицаИсточник = ПолучитьДанныеСпискаПоРеквизитам(СтруктураОтбора);
		
		Если НЕ ТаблицаИсточник = Неопределено Тогда
			ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, Список);
		КонецЕсли;
		
	ИначеЕсли РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоОборотам Тогда
		
		СтруктураОтбора = Новый Структура("НачПериода, КонПериода, Организация, Номенклатура, Склад, СчетУчета, ТипыДокументов",
		                                  НачалоПериода,
		                                  КонецПериода,
		                                  Организация,
		                                  Номенклатура,
		                                  Склад,
		                                  СчетУчета,
		                                  ТипыДокументов);
										  
		ТаблицаИсточник = ПолучитьДанныеСпискаПоОборотам(СтруктураОтбора);
		
		Если НЕ ТаблицаИсточник = Неопределено Тогда
			ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, Список);
		КонецЕсли;
		
	ИначеЕсли РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоОстаткам Тогда
		
		СтруктураОтбора = Новый Структура("НачПериода, КонПериода, Организация, Номенклатура, Склад, СчетУчета, ТипыДокументов",
		                                  НачалоПериода,
		                                  КонецПериода,
		                                  Организация,
		                                  Номенклатура,
		                                  Склад,
		                                  СчетУчета,
		                                  ТипыДокументов);
										  
		ТаблицаИсточник = ПолучитьДанныеСпискаПоОстаткам(СтруктураОтбора);
		
		Если НЕ ТаблицаИсточник = Неопределено Тогда
			ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, Список);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		СтандартнаяОбработка = Ложь;
		Возврат; 
	КонецЕсли;

	ТекущийДокумент = ТекущиеДанные.Документ;
	Если НЕ ЗначениеЗаполнено(ТекущийДокумент) Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ОповеститьОВыборе(ТекущийДокумент);

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Дата", КонецПериода);
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	
	ОткрытьФорму("Документ.Партия.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)

	Отказ = Истина;

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат; 
	КонецЕсли;

	ТекущийДокумент = ТекущиеДанные.Документ;
	Если НЕ ЗначениеЗаполнено(ТекущийДокумент) Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, ТекущийДокумент);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	РежимыОтбораДокументов = Новый Структура;
	РежимыОтбораДокументов.Вставить("ПоРеквизитам", Перечисления.РежимОтбораДокументов.ПоРеквизитам);
	РежимыОтбораДокументов.Вставить("ПоОстаткам", Перечисления.РежимОтбораДокументов.ПоОстаткам);
	РежимыОтбораДокументов.Вставить("ПоОборотам", Перечисления.РежимОтбораДокументов.ПоОборотам);
	
	Если Параметры.Свойство("ПараметрыОбъекта") Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ПараметрыОбъекта);
		Если ТипЗнч(Параметры.ПараметрыОбъекта.ТипыДокументов) = Тип("Строка") Тогда
			ТипыДокументов = Вычислить(Параметры.ПараметрыОбъекта.ТипыДокументов);
		Иначе
			ТипыДокументов = Параметры.ПараметрыОбъекта.ТипыДокументов;
		КонецЕсли;
	КонецЕсли;
	
	// КонПериода
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = КонецМесяца(ТекущаяДата());
	КонецЕсли;

	// НачПериода
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоМесяца(КонецПериода);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РежимОтбораДокументов) Тогда
		РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоРеквизитам;
	КонецЕсли;
	
	Если СчетУчета = Неопределено Тогда
		СчетУчета = ПланыСчетов.Хозрасчетный.ПустаяСсылка();		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТипыДокументов) тогда
		ТипыДокументов = Новый ОписаниеТипов("ДокументСсылка.Партия");
	КонецЕсли;
	
	Если ФормироватьСписокПриОткрытии Тогда
		СформироватьСервер();
	КонецЕсли;
	
	НаСчетеВедетсяУчетПоСкладам = БухгалтерскийУчетВызовСервераПовтИсп.ВедетсяУчетПоСкладам(СчетУчета);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ОповеститьОВыборе(НовыйОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Если НЕ СохранятьРежимОтбораДокументов Тогда
		Настройки.Удалить("РежимОтбораДокументов");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Параметры.Свойство("РежимОтбораДокументов") Тогда
		Настройки.Очистить();
	КонецЕсли;
	
	НастройкиИзменены = Ложь;
	
	Если ЗначениеЗаполнено(Настройки["РежимОтбораДокументов"]) Тогда
		Если РежимОтбораДокументов <> Настройки["РежимОтбораДокументов"] Тогда
			РежимОтбораДокументов = Настройки["РежимОтбораДокументов"];
			УправлениеФормой(ЭтаФорма);
			НастройкиИзменены = Истина;
		КонецЕсли;
	КонецЕсли; 
	
	Если (Настройки["ФормироватьСписокПриОткрытии"] = Истина) Тогда
		// Обновляем список, если он не был ранее сформирован ПриСозданииНаСервере()
		// или загруженные настройки отличаются.	
		Если НЕ ФормироватьСписокПриОткрытии ИЛИ НастройкиИзменены Тогда
			СформироватьСервер();
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры
