#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дата        = ОбщегоНазначенияБП.ПолучитьРабочуюДату();
	Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	Параметры.Свойство("Реестр", Реестр);	
	
КонецПроцедуры

#КонецОбласти  

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьРеестры(Команда)
	
	СформироватьРеестрыНаСервере();	
	
	Оповестить("Создан" + Реестр);	
	
КонецПроцедуры

&НаСервере
Процедура СформироватьРеестрыНаСервере()
	
	Если Реестр = "РеестрТТНВвоз" Тогда		
		
		ПараметрыРеестра = Новый Структура;
		ПараметрыРеестра.Вставить("ПериодС",            НачалоДня(Дата));
		ПараметрыРеестра.Вставить("ПериодПо",           КонецДня(Дата));
		ПараметрыРеестра.Вставить("Организация",        Организация);
		ПараметрыРеестра.Вставить("Владелец",           Справочники.Контрагенты.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ДоговорКонтрагента", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Поставщик",          Справочники.Контрагенты.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ВидХранения",        Справочники.ИНАГРО_ВидыХранения.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Склад",              Склад);          
		ПараметрыРеестра.Вставить("Силос",              Справочники.ИНАГРО_МестаХранения.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Номенклатура",       Справочники.Номенклатура.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Урожай",             Справочники.ИНАГРО_ВидыУрожая.ПустаяСсылка());
		ПараметрыРеестра.Вставить("НомерПробы",         0);
		ПараметрыРеестра.Вставить("СтВлажности",        Перечисления.ИНАГРО_СтепеньВлажности.ПустаяСсылка());
		ПараметрыРеестра.Вставить("СтЗагрязнения",      Перечисления.ИНАГРО_СтепеньЗагрязнения.ПустаяСсылка());
		ПараметрыРеестра.Вставить("СтЗараженности",     Перечисления.ИНАГРО_СтепеньЗараженности.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ЛабораторныйАнализ", Документы.ИНАГРО_ЛабораторныйАнализ.ПустаяСсылка());
		ПараметрыРеестра.Вставить("МестоХранения",      Справочники.ИНАГРО_МестаХранения.ПустаяСсылка());
		
		ИНАГРО_Элеватор.СформироватьРеестрТТН_Ввоз(ПараметрыРеестра);
		
	ИначеЕсли Реестр = "РеестрТТНВвозЖД" Тогда 		
		
		ПараметрыРеестра = Новый Структура;
		ПараметрыРеестра.Вставить("ПериодС",            НачалоДня(Дата));
		ПараметрыРеестра.Вставить("ПериодПо",           КонецДня(Дата));
		ПараметрыРеестра.Вставить("Организация",        Организация);
		ПараметрыРеестра.Вставить("Владелец",           Справочники.Контрагенты.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ДоговорКонтрагента", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ВидХранения",        Справочники.ИНАГРО_ВидыХранения.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Склад",              Склад);
		ПараметрыРеестра.Вставить("Номенклатура",       Справочники.Номенклатура.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Урожай",             Справочники.ИНАГРО_ВидыУрожая.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ЛабораторныйАнализ", Документы.ИНАГРО_ЛабораторныйАнализ.ПустаяСсылка());
		ПараметрыРеестра.Вставить("МестоХранения",      Справочники.ИНАГРО_МестаХранения.ПустаяСсылка());
		
		ИНАГРО_Элеватор.СформироватьРеестрТТН_ВвозЖД(ПараметрыРеестра);		
		
	ИначеЕсли Реестр = "РеестрТТНВнутр" Тогда			
		
		ПараметрыРеестра = Новый Структура;
		ПараметрыРеестра.Вставить("ПериодС",            НачалоДня(Дата));
		ПараметрыРеестра.Вставить("ПериодПо",           КонецДня(Дата));
		ПараметрыРеестра.Вставить("Организация",        Организация);				
		ПараметрыРеестра.Вставить("ВидХранения",        Справочники.ИНАГРО_ВидыХранения.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Склад",              Склад);
		ПараметрыРеестра.Вставить("НовыйСклад",         Справочники.Склады.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Номенклатура",       Справочники.Номенклатура.ПустаяСсылка());
		ПараметрыРеестра.Вставить("НоваяНоменклатура",  Справочники.Номенклатура.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Урожай",             Справочники.ИНАГРО_ВидыУрожая.ПустаяСсылка());
		ПараметрыРеестра.Вставить("НовыйУрожай",        Справочники.ИНАГРО_ВидыУрожая.ПустаяСсылка());
		ПараметрыРеестра.Вставить("МестоХранения",      Справочники.ИНАГРО_МестаХранения.ПустаяСсылка());
		ПараметрыРеестра.Вставить("НовоеМестоХранения", Справочники.ИНАГРО_МестаХранения.ПустаяСсылка());
		
		ИНАГРО_Элеватор.СформироватьРеестрТТН_Внутр(ПараметрыРеестра);		
		
	ИначеЕсли Реестр = "РеестрТТНВывоз" Тогда 
		
		ПараметрыРеестра = Новый Структура;
		ПараметрыРеестра.Вставить("ПериодС",            НачалоДня(Дата));
		ПараметрыРеестра.Вставить("ПериодПо",           КонецДня(Дата));
		ПараметрыРеестра.Вставить("Организация",        Организация);
		ПараметрыРеестра.Вставить("Владелец",           Справочники.Контрагенты.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ДоговорКонтрагента", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ВидХранения",        Справочники.ИНАГРО_ВидыХранения.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Склад",              Склад);
		ПараметрыРеестра.Вставить("Номенклатура",       Справочники.Номенклатура.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Урожай",             Справочники.ИНАГРО_ВидыУрожая.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ЛабораторныйАнализ", Документы.ИНАГРО_ЛабораторныйАнализ.ПустаяСсылка());
		ПараметрыРеестра.Вставить("СтЗараженности",     Перечисления.ИНАГРО_СтепеньЗараженности.ПустаяСсылка());
		ПараметрыРеестра.Вставить("МестоХранения",      Справочники.ИНАГРО_МестаХранения.ПустаяСсылка());
		
		ИНАГРО_Элеватор.СформироватьРеестрТТН_Вывоз(ПараметрыРеестра);		
		
	ИначеЕсли  Реестр = "РеестрТТНВывозЖД" Тогда
		
		ПараметрыРеестра = Новый Структура;
		ПараметрыРеестра.Вставить("ПериодС",            НачалоДня(Дата));
		ПараметрыРеестра.Вставить("ПериодПо",           КонецДня(Дата));
		ПараметрыРеестра.Вставить("Организация",        Организация);
		ПараметрыРеестра.Вставить("Владелец",           Справочники.Контрагенты.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ДоговорКонтрагента", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ВидХранения",        Справочники.ИНАГРО_ВидыХранения.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Склад",              Склад);
		ПараметрыРеестра.Вставить("Номенклатура",       Справочники.Номенклатура.ПустаяСсылка());
		ПараметрыРеестра.Вставить("Урожай",             Справочники.ИНАГРО_ВидыУрожая.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ЛабораторныйАнализ", Документы.ИНАГРО_ЛабораторныйАнализ.ПустаяСсылка());
		ПараметрыРеестра.Вставить("ПриказНаВывоз",      Документы.ИНАГРО_ПриказНаВывоз.ПустаяСсылка());
		ПараметрыРеестра.Вставить("МестоХранения",      Справочники.ИНАГРО_МестаХранения.ПустаяСсылка());
		
		ИНАГРО_Элеватор.СформироватьРеестрТТН_ВывозЖД(ПараметрыРеестра);		
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти