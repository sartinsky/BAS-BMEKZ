#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеФормой();   
	
	ИнициализироватьКомпоновщикНастроек();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ПеренестиВДокумент Тогда
		Если Найти(ЭтаФорма.ВладелецФормы.ИмяФормы, "ИНАГРО_ТабельУчетаРабочегоВремениОрганизации") <> 0 Тогда
			Объект.ЗаполнятьЗаПериод = Истина;
		КонецЕсли;
		
		СтруктураВозврата = Новый Структура;
		
		АдресТЗ = ОбработатьИзменениеОтборовНаСервере();
		
		СтруктураВозврата.Вставить("АдресТЗ", 	АдресТЗ);
		СтруктураВозврата.Вставить("Дата", Объект.ЗаполняемаяДата);
		СтруктураВозврата.Вставить("ПереключательХарактерВыплаты", ПереключательХарактерВыплаты);
		СтруктураВозврата.Вставить("Размер", Размер);
		СтруктураВозврата.Вставить("СпособВыплаты", СпособВыплаты);
		СтруктураВозврата.Вставить("Банк", Банк);
		СтруктураВозврата.Вставить("ВидРасчета", ВидРасчета);
		СтруктураВозврата.Вставить("ДатаНачала", Объект.ДатаНачала);
		СтруктураВозврата.Вставить("ДатаОкончания", Объект.ДатаОкончания);
		СтруктураВозврата.Вставить("БазовыйПериодНачало", БазовыйПериодНачало);
		СтруктураВозврата.Вставить("БазовыйПериодКонец", БазовыйПериодКонец);
		СтруктураВозврата.Вставить("Показатель1", Показатель1);
		СтруктураВозврата.Вставить("ИдентификаторВызывающейФормы", ВладелецФормы.УникальныйИдентификатор);
		
		Оповестить("ГрупповоеЗаполнение", СтруктураВозврата, ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособВыплатыПриИзменении(Элемент)
	Если СпособВыплаты = ПредопределенноеЗначение("Перечисление.СпособыВыплатыЗарплаты.ЧерезБанк")  Тогда
		Элементы.Банк.Доступность = Истина;
	Иначе
		Банк = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		Элементы.Банк.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПереключательХарактерВыплатыПриИзменении(Элемент)
	
	Если ПереключательХарактерВыплаты = 1  Тогда
		Элементы.Размер.Доступность = Ложь;
	Иначе
		Элементы.Размер.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВидРасчетаПриИзмененииНаСервере()   
	
	Если ЗначениеЗаполнено(Объект.ДатаНачала) И ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда 
		
		Если ВидРасчета.ВидПремии = Перечисления.ИНАГРО_ВидыПремии.ПремияЗаТекущийМесяц ИЛИ ВидРасчета.ВидПремии = Перечисления.ИНАГРО_ВидыПремии.ПремияПропорциональноЗаТекущийМесяц Тогда
			БазовыйПериодНачало = НачалоМесяца(Объект.ДатаНачала);
			БазовыйПериодКонец = КонецМесяца(Объект.ДатаНачала);
		ИначеЕсли НЕ ВидРасчета = ПланыВидовРасчета.ИНАГРО_Начисления.КомпенсацияЗарплаты Тогда
			БазовыйПериодНачало = ДобавитьМесяц(НачалоМесяца(Объект.ДатаНачала),-ВидРасчета.ЧислоМесяцев);
			БазовыйПериодКонец = КонецМесяца(ДобавитьМесяц(НачалоМесяца(Объект.ДатаНачала),-Мин(ВидРасчета.ЧислоМесяцев, 1)));
		КонецЕсли;
		
	КонецЕсли;  
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРасчетаПриИзменении(Элемент)
	ВидРасчетаПриИзмененииНаСервере();
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗаполнениеДокумента(Команда)
	
	ПеренестиВДокумент = Истина;	
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	Параметры.Свойство("ДатаАктуальности",         Объект.ДатаАктуальности);
	Параметры.Свойство("ДатаАктуальностиНачалоМесяца",  НачалоМесяца(Объект.ДатаАктуальности));
	Параметры.Свойство("ДатаУволенных",            Объект.ДатаУволенных);
	Параметры.Свойство("Организация",              Организация);
	Параметры.Свойство("ПодразделениеОрганизации", ПодразделениеОрганизации);
	Параметры.Свойство("ВключатьГПХ",              Объект.ВключатьРаботающихПоДоговорамГПХ); 
	Параметры.Свойство("ВключатьУволенных",        Объект.ВключатьУволенных);  
	Параметры.Свойство("ПоказатьХарактер",         Элементы.ГруппаХарактерВыплаты.Видимость);
	Параметры.Свойство("ПоказатьСпособВыплаты",    Элементы.ГруппаСпособВыплаты.Видимость);
	Параметры.Свойство("ПоказатьРазовыеРасчеты",   Элементы.ГруппаРазовыеРасчеты.Видимость);
	Параметры.Свойство("ДатаНачала",               Объект.ДатаНачала); 
	Параметры.Свойство("ДатаОкончания",        	   Объект.ДатаОкончания);  
	
	Объект.ВыбиратьСотрудника	 = Истина;
	ПереключательХарактерВыплаты = 1;
	
		
	СпособВыплаты = ПредопределенноеЗначение("Перечисление.СпособыВыплатыЗарплаты.ЧерезБанк");
	Банк          = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");

	Элементы.Размер.Доступность = Ложь;
	Элементы.Банк.Доступность   = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроек()
	
	ТекстЗапроса = ПолучитьТекстЗапроса(Объект.ВыбиратьСотрудника, Объект.ВключатьУволенных, Объект.ВключатьРаботающихПоДоговорамГПХ);
	
	СхемаКомпоновкиДанных = СхемаКомпоновкиДанных(ТекстЗапроса);
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор)));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Параметры.Организация;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодразделениеОрганизации");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Если ЗначениеЗаполнено(ПодразделениеОрганизации) Тогда
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ПодразделениеОрганизации;
	Иначе	
		ЭлементОтбора.Использование = Ложь;
	КонецЕсли;
	
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Должность");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Ложь;
	
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудник");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.Использование = Ложь;
	
КонецПроцедуры

&НаСервере
Функция СхемаКомпоновкиДанных(ТекстЗапроса)
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "local";
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.ИсточникДанных = "ИсточникДанных1";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	НаборДанных.Запрос = ТекстЗапроса;
	НаборДанных.Имя = "НаборДанных1";
	
	Возврат СхемаКомпоновкиДанных;
	
КонецФункции

&НаСервере
Функция ОбработатьИзменениеОтборовНаСервере()

	ТекстЗапроса = ПолучитьТекстЗапроса(Объект.ВыбиратьСотрудника, Объект.ВключатьУволенных, Объект.ВключатьРаботающихПоДоговорамГПХ);
	
	СхемаКомпоновкиДанных = СхемаКомпоновкиДанных(ТекстЗапроса);
	
	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(КомпоновщикНастроек.Настройки);
	
	Для Каждого Элемент Из КомпоновщикНастроекКомпоновкиДанных.Настройки.Выбор.ДоступныеПоляВыбора.Элементы Цикл
		Если Не Элемент.Папка Тогда
			Поле = КомпоновщикНастроекКомпоновкиДанных.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			Поле.Использование = Истина;
			Поле.Поле = Элемент.Поле;
		КонецЕсли;
	КонецЦикла;
	Группа = КомпоновщикНастроекКомпоновкиДанных.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Группа.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));	

    НастройкиКомпоновщика = КомпоновщикНастроекКомпоновкиДанных.Настройки;
    ПараметрыНастройки = НастройкиКомпоновщика.ПараметрыДанных;	
	
    НайденноеЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаАктуальности"));
    Если НайденноеЗначениеПараметра <> Неопределено Тогда
        НайденноеЗначениеПараметра.Использование = Истина;
        НайденноеЗначениеПараметра.Значение = Объект.ДатаАктуальности;
	КонецЕсли;
	
    НайденноеЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаАктуальностиНачалоМесяца"));
    Если НайденноеЗначениеПараметра <> Неопределено Тогда
        НайденноеЗначениеПараметра.Использование = Истина;
        НайденноеЗначениеПараметра.Значение = НачалоМесяца(Объект.ДатаАктуальности);
	КонецЕсли;

   	НайденноеЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Организация"));
    Если НайденноеЗначениеПараметра <> Неопределено Тогда
        НайденноеЗначениеПараметра.Использование = Истина;
        НайденноеЗначениеПараметра.Значение = Организация;
	КонецЕсли;
	
   	НайденноеЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПодразделениеОрганизации"));
    Если НайденноеЗначениеПараметра <> Неопределено Тогда
        НайденноеЗначениеПараметра.Использование = Истина;
        НайденноеЗначениеПараметра.Значение = ПодразделениеОрганизации;
	КонецЕсли;
	
   	НайденноеЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаУволенных"));
    Если НайденноеЗначениеПараметра <> Неопределено Тогда
        НайденноеЗначениеПараметра.Использование = Истина;
        НайденноеЗначениеПараметра.Значение = Объект.ДатаУволенных;
    КонецЕсли;

   	НайденноеЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПустаяДата"));
    Если НайденноеЗначениеПараметра <> Неопределено Тогда
        НайденноеЗначениеПараметра.Использование = Истина;
        НайденноеЗначениеПараметра.Значение = Дата('00010101');
	КонецЕсли;
	
   	НайденноеЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Выплачено"));
    Если НайденноеЗначениеПараметра <> Неопределено Тогда
        НайденноеЗначениеПараметра.Использование = Истина;
        НайденноеЗначениеПараметра.Значение = Перечисления.ВыплаченностьЗарплаты.Выплачено;
	КонецЕсли;
	
   	НайденноеЗначениеПараметра = ПараметрыНастройки.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЗаполняемаяДата"));
    Если НайденноеЗначениеПараметра <> Неопределено Тогда
        НайденноеЗначениеПараметра.Использование = Истина;
        НайденноеЗначениеПараметра.Значение = Объект.ЗаполняемаяДата;
	КонецЕсли;

	Результат = Новый ТаблицаЗначений;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Попытка
		МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
			КомпоновщикНастроекКомпоновкиДанных.Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	Исключение
		ТекстСообщенияОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());		
	КонецПопытки;
		
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	АдресСпискаВыбранных = ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	
	Возврат АдресСпискаВыбранных;
	
КонецФункции

Функция ПолучитьТекстЗапроса(ВыбиратьСотрудника = Истина, ВключатьУволенных = Ложь, ВключатьРаботающихПоДоговорамГПХ = Ложь)
	
	ТекстЗапроса = "";
	
	Если ВыбиратьСотрудника Тогда
		
		ТекстЗапроса ="ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	Результат.Организация,
			|	Результат.ПодразделениеОрганизации,
			|	Результат.Сотрудник,
			|	Результат.Сотрудник.ФизическоеЛицо,
			|	Результат.ПричинаИзмененияСостояния,
			|	Результат.ВидЗанятости,
			|	Результат.ТабельныйНомер,
			|	Результат.ГрафикРаботы,
			|	Результат.ЗанимаемыхСтавок,
			|	Результат.Должность,
			|	Результат.СпособОтраженияВБухучете,
			|	Результат.ДатаПриема,
			|	Результат.СпособВыплаты,
			|	Результат.Банк,
			|	Результат.НомерКарточки,
			|	Результат.ДатаДействия,
			|	Результат.ВыплаченностьЗарплаты,
			|	Результат.ДатаНачала,
		 	|	Результат.Сотрудник.Наименование КАК СотрудникНаименование
			|ИЗ
			|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|		РаботникиОрганизацииСрез.Сотрудник КАК Сотрудник,
			|		РаботникиОрганизацииСрез.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
			|		РаботникиОрганизацииСрез.ПричинаИзмененияСостояния КАК ПричинаИзмененияСостояния,
			|		РаботникиОрганизацииСрез.Сотрудник.ИНАГРО_ВидЗанятости КАК ВидЗанятости,
			|		РаботникиОрганизацииСрез.Сотрудник.Код КАК ТабельныйНомер,
			|		РаботникиОрганизацииСрез.ГрафикРаботы КАК ГрафикРаботы,
			|		РаботникиОрганизацииСрез.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
			|		РаботникиОрганизацииСрез.Должность КАК Должность,
			|		РаботникиОрганизацииСрез.СпособОтраженияВБухучете КАК СпособОтраженияВБухучете,
			|		ЕСТЬNULL(ДатаПриемаСотрудника.ДатаПриема, &ПустаяДата) КАК ДатаПриема,
			|		РаботникиОрганизацииСрез.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
			|		СпособыВыплаты.СпособВыплаты КАК СпособВыплаты,
			|		СпособыВыплаты.Банк КАК Банк,
			|		СпособыВыплаты.НомерКарточки КАК НомерКарточки,
			|		СпособыВыплаты.ДатаДействия КАК ДатаДействия,
			|		&Выплачено КАК ВыплаченностьЗарплаты,
			|		&ЗаполняемаяДата КАК ДатаНачала,
			|		РаботникиОрганизацииСрез.Организация КАК Организация,
			|		РаботникиОрганизацииСрез.Регистратор КАК Регистратор
			|
			|	ИЗ
			|		РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК РаботникиОрганизацииСрез
			|
			|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
			|				ИНАГРО_РаботникиОрганизаций.Сотрудник КАК Сотрудник,
			|				МИНИМУМ(ИНАГРО_РаботникиОрганизаций.Период) КАК ДатаПриема
			|			ИЗ
			|				РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК ИНАГРО_РаботникиОрганизаций
			|			
			|			СГРУППИРОВАТЬ ПО
			|				ИНАГРО_РаботникиОрганизаций.Сотрудник) КАК ДатаПриемаСотрудника
			|			ПО РаботникиОрганизацииСрез.Сотрудник = ДатаПриемаСотрудника.Сотрудник
			|			{ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
			|				ДатыПоследнихДвиженийРаботников.Период КАК Период,
			|				ДатыПоследнихДвиженийРаботников.Сотрудник КАК Сотрудник,
			|				ДанныеПоРаботникуПриНазначении.Регистратор КАК Приказ
			|			ИЗ
			|				(ВЫБРАТЬ
			|					МАКСИМУМ(Работники.Период) КАК Период,
			|					ТЧРаботникиОрганизации.Сотрудник КАК Сотрудник
			|				ИЗ
			|					РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК ТЧРаботникиОрганизации
			|						ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК Работники
			|						ПО (Работники.Период <= ТЧРаботникиОрганизации.Период)
			|							И (Работники.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу))
			|							И ТЧРаботникиОрганизации.Сотрудник = Работники.Сотрудник
			|				{ГДЕ
			|					ТЧРаботникиОрганизации.Должность КАК Должность,
			|					ТЧРаботникиОрганизации.ГрафикРаботы КАК ГрафикРаботы,
			|					ТЧРаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
			|					ТЧРаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
			|					ТЧРаботникиОрганизации.Организация КАК Организация,
			|					ТЧРаботникиОрганизации.ПодразделениеОрганизации КАК Подразделение}
			|				
			|				СГРУППИРОВАТЬ ПО
			|					ТЧРаботникиОрганизации.Сотрудник) КАК ДатыПоследнихДвиженийРаботников
			|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК ДанныеПоРаботникуПриНазначении
			|					ПО ДатыПоследнихДвиженийРаботников.Период = ДанныеПоРаботникуПриНазначении.Период
			|						И ДатыПоследнихДвиженийРаботников.Сотрудник = ДанныеПоРаботникуПриНазначении.Сотрудник) КАК ПриказыОПриеме
			|			ПО РаботникиОрганизацииСрез.Сотрудник = ПриказыОПриеме.Сотрудник}
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_ПараметрыВыплатыЗПРаботников.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК СпособыВыплаты
			|			ПО (СпособыВыплаты.Сотрудник = РаботникиОрганизацииСрез.Сотрудник)
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЛьготыПоНДФЛСотрудников.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК ЛьготыРаботников
			|			ПО (ЛьготыРаботников.ИНАГРО_Сотрудник = РаботникиОрганизацииСрез.Сотрудник)
			|				И (ЛьготыРаботников.Актуальность)
			|		//ДАННЫЕ О ФИЗЛИЦЕ: СОЕДИНЕНИЯ
			|		// СОЕДИНЕНИЯ СВОЙСТВ И КАТЕГОРИЙ
			|// УСЛОВИЕ 			
			|	{ГДЕ
			|		РаботникиОрганизацииСрез.Сотрудник КАК Работник,
			|		РаботникиОрганизацииСрез.Должность.* КАК Должность,
			|		РаботникиОрганизацииСрез.ГрафикРаботы.* КАК ГрафикРаботы,
			|		РаботникиОрганизацииСрез.Сотрудник.Код КАК ТабельныйНомер,
			|		РаботникиОрганизацииСрез.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
			|		ПриказыОПриеме.Период КАК ДатаПриема,
			|		РаботникиОрганизацииСрез.Сотрудник.ИНАГРО_ВидЗанятости КАК ВидЗанятости,
			|		РаботникиОрганизацииСрез.ПодразделениеОрганизации.* КАК Подразделение,
			|		РаботникиОрганизацииСрез.Организация.* КАК Организация,
			|		ЛьготыРаботников.Льгота КАК ЛьготаНДФЛ}) КАК Результат
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК ИНАГРО_РаботникиОрганизаций
			|		ПО ИНАГРО_РаботникиОрганизаций.Сотрудник = Результат.Сотрудник
			|			И ИНАГРО_РаботникиОрганизаций.ПодразделениеОрганизации = Результат.ПодразделениеОрганизации
			|			И ИНАГРО_РаботникиОрганизаций.Организация = Результат.Организация
			|			И ИНАГРО_РаботникиОрганизаций.Должность = Результат.Должность
			|			И ИНАГРО_РаботникиОрганизаций.ГрафикРаботы = Результат.ГрафикРаботы
			|			И ИНАГРО_РаботникиОрганизаций.ЗанимаемыхСтавок = Результат.ЗанимаемыхСтавок
			|			И ИНАГРО_РаботникиОрганизаций.Регистратор = Результат.Регистратор
			|			И ИНАГРО_РаботникиОрганизаций.ПричинаИзмененияСостояния = Результат.ПричинаИзмененияСостояния
			|
			|";
		Если Объект.ЗаполнятьЗаПериод Тогда
			ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ   
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Результат.Организация,
			|	Результат.ПодразделениеОрганизации,
			|	Результат.Сотрудник,
			|	Результат.Сотрудник.ФизическоеЛицо,
			|	Результат.ПричинаИзмененияСостояния,
			|	Результат.ВидЗанятости,
			|	Результат.ТабельныйНомер,
			|	Результат.ГрафикРаботы,
			|	Результат.ЗанимаемыхСтавок,
			|	Результат.Должность,
			|	Результат.СпособОтраженияВБухучете,
			|	Результат.ДатаПриема,
			|	Результат.СпособВыплаты,
			|	Результат.Банк,
			|	Результат.НомерКарточки,
			|	Результат.ДатаДействия,
			|	Результат.ВыплаченностьЗарплаты,
			|	Результат.ДатаНачала,
			|	Результат.Сотрудник.Наименование
			|ИЗ
			|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|		РаботникиОрганизацииСрез.Сотрудник КАК Сотрудник,
			|		РаботникиОрганизацииСрез.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
			|		РаботникиОрганизацииСрез.ПричинаИзмененияСостояния КАК ПричинаИзмененияСостояния,
			|		РаботникиОрганизацииСрез.Сотрудник.ИНАГРО_ВидЗанятости КАК ВидЗанятости,
			|		РаботникиОрганизацииСрез.Сотрудник.Код КАК ТабельныйНомер,
			|		РаботникиОрганизацииСрез.ГрафикРаботы КАК ГрафикРаботы,
			|		РаботникиОрганизацииСрез.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
			|		РаботникиОрганизацииСрез.Должность КАК Должность,
			|		РаботникиОрганизацииСрез.СпособОтраженияВБухучете КАК СпособОтраженияВБухучете,
			|		ЕСТЬNULL(ДатаПриемаСотрудника.ДатаПриема, &ПустаяДата) КАК ДатаПриема,
			|		РаботникиОрганизацииСрез.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
			|		СпособыВыплаты.СпособВыплаты КАК СпособВыплаты,
			|		СпособыВыплаты.Банк КАК Банк,
			|		СпособыВыплаты.НомерКарточки КАК НомерКарточки,
			|		СпособыВыплаты.ДатаДействия КАК ДатаДействия,
			|		&Выплачено КАК ВыплаченностьЗарплаты,
			|		&ЗаполняемаяДата КАК ДатаНачала,
			|		РаботникиОрганизацииСрез.Организация КАК Организация,
			|		РаботникиОрганизацииСрез.Регистратор КАК Регистратор
			|
			|	ИЗ
			|		РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&ДатаАктуальностиНачалоМесяца, Организация = &Организация) КАК РаботникиОрганизацииСрез
			|
			|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
			|				ИНАГРО_РаботникиОрганизаций.Сотрудник КАК Сотрудник,
			|				МИНИМУМ(ИНАГРО_РаботникиОрганизаций.Период) КАК ДатаПриема
			|			ИЗ
			|				РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК ИНАГРО_РаботникиОрганизаций
			|			
			|			СГРУППИРОВАТЬ ПО
			|				ИНАГРО_РаботникиОрганизаций.Сотрудник) КАК ДатаПриемаСотрудника
			|			ПО РаботникиОрганизацииСрез.Сотрудник = ДатаПриемаСотрудника.Сотрудник
			|			{ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
			|				ДатыПоследнихДвиженийРаботников.Период КАК Период,
			|				ДатыПоследнихДвиженийРаботников.Сотрудник КАК Сотрудник,
			|				ДанныеПоРаботникуПриНазначении.Регистратор КАК Приказ
			|			ИЗ
			|				(ВЫБРАТЬ
			|					МАКСИМУМ(Работники.Период) КАК Период,
			|					ТЧРаботникиОрганизации.Сотрудник КАК Сотрудник
			|				ИЗ
			|					РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&ДатаАктуальностиНачалоМесяца, Организация = &Организация) КАК ТЧРаботникиОрганизации
			|						ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК Работники
			|						ПО (Работники.Период <= ТЧРаботникиОрганизации.Период)
			|							И (Работники.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу))
			|							И ТЧРаботникиОрганизации.Сотрудник = Работники.Сотрудник
			|				{ГДЕ
			|					ТЧРаботникиОрганизации.Должность КАК Должность,
			|					ТЧРаботникиОрганизации.ГрафикРаботы КАК ГрафикРаботы,
			|					ТЧРаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
			|					ТЧРаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
			|					ТЧРаботникиОрганизации.Организация КАК Организация,
			|					ТЧРаботникиОрганизации.ПодразделениеОрганизации КАК Подразделение}
			|				
			|				СГРУППИРОВАТЬ ПО
			|					ТЧРаботникиОрганизации.Сотрудник) КАК ДатыПоследнихДвиженийРаботников
			|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК ДанныеПоРаботникуПриНазначении
			|					ПО ДатыПоследнихДвиженийРаботников.Период = ДанныеПоРаботникуПриНазначении.Период
			|						И ДатыПоследнихДвиженийРаботников.Сотрудник = ДанныеПоРаботникуПриНазначении.Сотрудник) КАК ПриказыОПриеме
			|			ПО РаботникиОрганизацииСрез.Сотрудник = ПриказыОПриеме.Сотрудник}
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_ПараметрыВыплатыЗПРаботников.СрезПоследних(&ДатаАктуальностиНачалоМесяца, Организация = &Организация) КАК СпособыВыплаты
			|			ПО (СпособыВыплаты.Сотрудник = РаботникиОрганизацииСрез.Сотрудник)
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЛьготыПоНДФЛСотрудников.СрезПоследних(&ДатаАктуальностиНачалоМесяца, Организация = &Организация) КАК ЛьготыРаботников
			|			ПО (ЛьготыРаботников.ИНАГРО_Сотрудник = РаботникиОрганизацииСрез.Сотрудник)
			|				И (ЛьготыРаботников.Актуальность)
			|		//ДАННЫЕ О ФИЗЛИЦЕ: СОЕДИНЕНИЯ
			|		// СОЕДИНЕНИЯ СВОЙСТВ И КАТЕГОРИЙ
			|// УСЛОВИЕ 			
			|	{ГДЕ
			|		РаботникиОрганизацииСрез.Сотрудник КАК Работник,
			|		РаботникиОрганизацииСрез.Должность.* КАК Должность,
			|		РаботникиОрганизацииСрез.ГрафикРаботы.* КАК ГрафикРаботы,
			|		РаботникиОрганизацииСрез.Сотрудник.Код КАК ТабельныйНомер,
			|		РаботникиОрганизацииСрез.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
			|		ПриказыОПриеме.Период КАК ДатаПриема,
			|		РаботникиОрганизацииСрез.Сотрудник.ИНАГРО_ВидЗанятости КАК ВидЗанятости,
			|		РаботникиОрганизацииСрез.ПодразделениеОрганизации.* КАК Подразделение,
			|		РаботникиОрганизацииСрез.Организация.* КАК Организация,
			|		ЛьготыРаботников.Льгота КАК ЛьготаНДФЛ}) КАК Результат
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК ИНАГРО_РаботникиОрганизаций
			|		ПО ИНАГРО_РаботникиОрганизаций.Сотрудник = Результат.Сотрудник
			|			И ИНАГРО_РаботникиОрганизаций.ПодразделениеОрганизации = Результат.ПодразделениеОрганизации
			|			И ИНАГРО_РаботникиОрганизаций.Организация = Результат.Организация
			|			И ИНАГРО_РаботникиОрганизаций.Должность = Результат.Должность
			|			И ИНАГРО_РаботникиОрганизаций.ГрафикРаботы = Результат.ГрафикРаботы
			|			И ИНАГРО_РаботникиОрганизаций.ЗанимаемыхСтавок = Результат.ЗанимаемыхСтавок
			|			И ИНАГРО_РаботникиОрганизаций.Регистратор = Результат.Регистратор
			|			И ИНАГРО_РаботникиОрганизаций.ПричинаИзмененияСостояния = Результат.ПричинаИзмененияСостояния
			|";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + "УПОРЯДОЧИТЬ ПО
		|	СотрудникНаименование";
		
	Иначе
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	РаботникиОрганизации.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
			|	РаботникиОрганизации.ПричинаИзмененияСостояния КАК ПричинаИзмененияСостояния,		
			|	РаботникиОрганизации.Сотрудник.ИНАГРО_ВидЗанятости КАК ВидЗанятости,
			|	&ЗаполняемаяДата КАК ДатаНачала
			|ИЗ
			|	РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК РаботникиОрганизации
			|		{ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
			|			ДатыПоследнихДвиженийРаботников.Период КАК Период,
			|			ДатыПоследнихДвиженийРаботников.Организация КАК Организация,
			|			ДатыПоследнихДвиженийРаботников.ФизическоеЛицо КАК ФизическоеЛицо,
			|			ДанныеПоРаботникуПриНазначении.Регистратор КАК Приказ
			|		ИЗ
			|			(ВЫБРАТЬ
			|				МАКСИМУМ(Работники.Период) КАК Период,
			|				ТЧРаботникиОрганизации.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
			|				ТЧРаботникиОрганизации.Организация КАК Организация
			|			ИЗ
			|				РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК ТЧРаботникиОрганизации
			|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК Работники
			|					ПО Работники.Период <= ТЧРаботникиОрганизации.Период
			|						И (Работники.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу))
			|						И ТЧРаботникиОрганизации.Сотрудник = Работники.Сотрудник
			|			{ГДЕ
			|				ТЧРаботникиОрганизации.Должность КАК Должность,
			|				ТЧРаботникиОрганизации.ГрафикРаботы КАК ГрафикРаботы,
			|				ТЧРаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
			|				ТЧРаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
			|				ТЧРаботникиОрганизации.Организация КАК Организация,
			|				ТЧРаботникиОрганизации.ПодразделениеОрганизации КАК Подразделение}
			|			
			|			СГРУППИРОВАТЬ ПО
			|				ТЧРаботникиОрганизации.Сотрудник.ФизическоеЛицо,
			|				ТЧРаботникиОрганизации.Организация) КАК ДатыПоследнихДвиженийРаботников
			|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций КАК ДанныеПоРаботникуПриНазначении
			|				ПО ДатыПоследнихДвиженийРаботников.Период = ДанныеПоРаботникуПриНазначении.Период
			|					И ДатыПоследнихДвиженийРаботников.ФизическоеЛицо = ДанныеПоРаботникуПриНазначении.Сотрудник.ФизическоеЛицо
			|					И ДатыПоследнихДвиженийРаботников.Организация = ДанныеПоРаботникуПриНазначении.Сотрудник.ГоловнаяОрганизация) КАК ПриказыОПриеме
			|		ПО РаботникиОрганизации.Сотрудник.ФизическоеЛицо = ПриказыОПриеме.ФизическоеЛицо
			|			И РаботникиОрганизации.Сотрудник.ГоловнаяОрганизация = ПриказыОПриеме.Организация}
			|		// ДАННЫЕ О ФИЗЛИЦЕ: СОЕДИНЕНИЯ
			|		// СОЕДИНЕНИЯ СВОЙСТВ И КАТЕГОРИЙ
			|// УСЛОВИЕ
			|{ГДЕ
			|	РаботникиОрганизации.Сотрудник КАК Работник,
			|	РаботникиОрганизации.Должность.* КАК Должность,
			|	РаботникиОрганизации.ГрафикРаботы.* КАК ГрафикРаботы,
			|	РаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
			|	РаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
			|	ПриказыОПриеме.Период КАК ДатаПриема,
			|	РаботникиОрганизации.Сотрудник.ИНАГРО_ВидЗанятости КАК ВидЗанятости,
			|	РаботникиОрганизации.ПодразделениеОрганизации.* КАК Подразделение,
			|	РаботникиОрганизации.Организация.* КАК Организация
			|	// ДАННЫЕ О ФИЗЛИЦЕ: ПОЛЯ
			|	// СВОЙСТВА
			|	// КАТЕГОРИИ
			|}
			|
			|УПОРЯДОЧИТЬ ПО
			|	РаботникиОрганизации.Сотрудник.ФизическоеЛицо.Наименование";
		
	КонецЕсли;
	
	Если ВключатьРаботающихПоДоговорамГПХ Тогда
		
		ИскомаяСтрока = "РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК РаботникиОрганизацииСрез
		|";
		СтрокаЗапроса = "
			|(
			|	ВЫБРАТЬ
			|	РаботникиОрганизации.Период КАК Период,
			|	РаботникиОрганизации.Сотрудник КАК Сотрудник,
			|	РаботникиОрганизации.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
			|	РаботникиОрганизации.ПричинаИзмененияСостояния КАК ПричинаИзмененияСостояния,		
			|	РаботникиОрганизации.Сотрудник.ИНАГРО_ВидЗанятости КАК ВидЗанятости,
			|	РаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
			|	РаботникиОрганизации.ГрафикРаботы КАК ГрафикРаботы,		
			|	РаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,		
			|	РаботникиОрганизации.Должность КАК Должность,
			|	РаботникиОрганизации.СпособОтраженияВБухучете КАК СпособОтраженияВБухучете,
			|	РаботникиОрганизации.ПодразделениеОрганизации КАК ПодразделениеОрганизации,		
			|	РаботникиОрганизации.Организация КАК Организация,
			|	&ЗаполняемаяДата КАК ДатаНачала,
			|   РаботникиОрганизации.Регистратор КАК Регистратор
			|ИЗ РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности, Организация = &Организация) КАК РаботникиОрганизации
			|	
			|	ОБЪЕДИНИТЬ ВСЕ 
			|	
			|	ВЫБРАТЬ РАЗЛИЧНЫЕ
			|   &ДатаАктуальности,
			|	ВЫБОР
			|		КОГДА ДоговорникиОрганизаций.Сотрудник.ОсновноеНазначение <> ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)
			|			ТОГДА ДоговорникиОрганизаций.Сотрудник.ОсновноеНазначение
			|		ИНАЧЕ ДоговорникиОрганизаций.Сотрудник
			|	КОНЕЦ,	
			|	ДоговорникиОрганизаций.Сотрудник.ФизическоеЛицо,
			|	""ГПХ"",		
			|	NULL,
			|	ДоговорникиОрганизаций.Сотрудник.Код,
			|	NULL,		
			|	NULL,		
			|	NULL,
			|	NULL,
			|	ДоговорникиОрганизаций.ПодразделениеОрганизации,		
			|	ДоговорникиОрганизаций.Организация,
			|	&ЗаполняемаяДата КАК ДатаНачала,
			|	ДоговорникиОрганизаций.Ссылка
			|
			|ИЗ
			|	Документ.ИНАГРО_ДоговорНаВыполнениеРаботСФизЛицом КАК ДоговорникиОрганизаций
			|ГДЕ
			|	ДоговорникиОрганизаций.Проведен
			|	И ДоговорникиОрганизаций.ДатаОкончания >= &ДатаАктуальности
			|	И ДоговорникиОрганизаций.ДатаНачала <= КОНЕЦПЕРИОДА(&ДатаАктуальности, МЕСЯЦ) 
			|	И ДоговорникиОрганизаций.Организация = &Организация
			|	И ДоговорникиОрганизаций.Сотрудник.ИНАГРО_ДоговорПодряда )	
			|	КАК РаботникиОрганизацииСрез
			|";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ИскомаяСтрока, СтрокаЗапроса);

	КонецЕсли;
	
	Если Не ВключатьУволенных Тогда
		
		СтрокаУсловия =
		"ГДЕ
		|	РаботникиОрганизацииСрез.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
		|";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// УСЛОВИЕ", СтрокаУсловия);
		
	ИначеЕсли ЗначениеЗаполнено(Объект.ДатаУволенных) Тогда
		
		СтрокаУсловия =
		"ГДЕ
		|	(РаботникиОрганизацииСрез.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)) ИЛИ (РаботникиОрганизацииСрез.Период > &ДатаУволенных)
		|";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// УСЛОВИЕ", СтрокаУсловия);
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти