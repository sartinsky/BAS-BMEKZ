////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, Счет, Суффикс = "")
	
	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
	                            "Субконто" + Суффикс + "1", "Субконто" + Суффикс + "2", "Субконто" + Суффикс + "3");
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
	                                 "ЗаголовокСубконто" + Суффикс + "1", "ЗаголовокСубконто" + Суффикс + "2", 
	                                 "ЗаголовокСубконто" + Суффикс + "3"); 
	
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Счет, Форма, ПоляФормы, ЗаголовкиПолей);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(Счет, ПараметрыОбъекта)

	СписокПараметров = Новый Структура;
	
	СписокПараметров.Вставить("СчетУчета"  ,   Счет);
	СписокПараметров.Вставить("Организация",   ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));
	
	Возврат СписокПараметров;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьНУ(Форма, Объект)
	
	ХарактерЗатрат 			   = Неопределено;
	ЦелевоеНалоговоеНазначение = Неопределено;
	
	Аналитика = Новый Структура;
	
	Аналитика.Вставить("СубконтоДт1",   Объект.СубконтоДт1);
	Аналитика.Вставить("СубконтоДт2",   Объект.СубконтоДт2);
	Аналитика.Вставить("СубконтоДт3",   Объект.СубконтоДт3);
	
	ШаблонНалоговоеНазначение = НСтр("ru='Налоговое назначение (НДС) заполняется автоматически: ';uk='Податкове призначення (ПДВ) заповнюється автоматично: '");
	
	
	
	НалоговыйУчет.ОпределениеАналитикиНалоговогоУчетаВПроводкахДляЗатрат(Аналитика, Объект.СчетДт, ХарактерЗатрат,
													       	ЦелевоеНалоговоеНазначение, , 
															Неопределено, Неопределено,
															"СубконтоДт");
															
	Форма.Элементы.НалоговоеНазначениеДоходовИЗатрат.ТолькоПросмотр  = Истина;
	Форма.Элементы.НалоговоеНазначение.ТолькоПросмотр  = Истина;
	Форма.Элементы.НадписьНалоговоеНазначение.Заголовок  = "";
	
	Если ХарактерЗатрат = "ОПЗ" Тогда
		
		// для ОПЗ мы будем отображать как налоговое назначение по прибыли (по НК до 01.08.2011) так и по НДС (после 01.08.2011, согласно Закона 3609)
		Форма.Элементы.НалоговоеНазначениеДоходовИЗатрат.ТолькоПросмотр  = Ложь;
		Форма.Элементы.НалоговоеНазначение.ТолькоПросмотр  = Ложь;
		
	ИначеЕсли ХарактерЗатрат = "Затраты" Тогда
		
		Форма.Элементы.НалоговоеНазначениеДоходовИЗатрат.ТолькоПросмотр  = Ложь;
		
	ИначеЕсли (ХарактерЗатрат = "Производство" ИЛИ ХарактерЗатрат = "Строительство") Тогда
		
		Форма.Элементы.НадписьНалоговоеНазначение.Заголовок = ШаблонНалоговоеНазначение + Строка(ЦелевоеНалоговоеНазначение);
		Объект.НалоговоеНазначение = ЦелевоеНалоговоеНазначение;
		
	ИначеЕсли ХарактерЗатрат = "РБП" Тогда
		
		Если    ЦелевоеНалоговоеНазначение = Неопределено Тогда
			// можно указать в справочнике 
			Форма.Элементы.НалоговоеНазначение.ТолькоПросмотр  = Ложь;		
			
		Иначе
			// из нал. назн. внутри РБП
			Форма.Элементы.НадписьНалоговоеНазначение.Заголовок = ШаблонНалоговоеНазначение + Строка(ЦелевоеНалоговоеНазначение);			
		КонецЕсли;
		
	ИначеЕсли ХарактерЗатрат = "ТЗР" Тогда
		
		Форма.Элементы.НалоговоеНазначение.ТолькоПросмотр  = Ложь;		
		
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьСпособОтраженияЕСВФОТ(Форма)
	
	Если НуженСпособОтраженияЕСВФОТ() Тогда
		Форма.Элементы.СпособОтраженияЕСВФОТ.ТолькоПросмотр = Истина;
	Иначе
		Форма.Элементы.СпособОтраженияЕСВФОТ.ТолькоПросмотр = Ложь;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Функция НуженСпособОтраженияЕСВФОТ()
	
	Если Объект.СтратегияОтраженияЕСВФОТ <> Перечисления.СтратегииОтраженияВУчетеЕСВ.ОсобымСпособом
		И Объект.СпособОтраженияЕСВФОТ <> Справочники.СпособыОтраженияЗарплатыВРеглУчете.ПустаяСсылка() Тогда
		  Объект.СпособОтраженияЕСВФОТ = Справочники.СпособыОтраженияЗарплатыВРеглУчете.ПустаяСсылка();
	КонецЕсли;	  
	
	Возврат Объект.СтратегияОтраженияЕСВФОТ <> Перечисления.СтратегииОтраженияВУчетеЕСВ.ОсобымСпособом;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗначениеПоУмолчанию(Настройка)

	Возврат БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию(Настройка);

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
//

&НаКлиенте
Процедура СчетДтПриИзменении(Элемент)
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетДт, "Дт");
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3", 
	                              "СубконтоДт1", "СубконтоДт2", "СубконтоДт3");
	
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетДт, Объект, ПоляОбъекта);

	УстановитьДоступностьНУ(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетКтПриИзменении(Элемент)
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетКт, "Кт");
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3", 
	                              "СубконтоКт1", "СубконтоКт2", "СубконтоКт3");
	
	БухгалтерскийУчетКлиентСервер.ПриИзмененииСчета(Объект.СчетКт, Объект, ПоляОбъекта);

КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ПараметрыДокумента = СписокПараметровВыбораСубконто(Объект.СчетДт, "Субконто%Индекс%");
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыДокумента);

КонецПроцедуры

&НаКлиенте
Процедура СубконтоКтНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ПараметрыДокумента = СписокПараметровВыбораСубконто(Объект.СчетКт, "Субконто%Индекс%");
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, СтандартнаяОбработка, ПараметрыДокумента);

КонецПроцедуры

&НаКлиенте
Процедура СтратегияОтраженияЕСВФОТПриИзменении(Элемент)
	
	УстановитьДоступностьСпособОтраженияЕСВФОТ(ЭтаФорма);
	ЗаполнитьВзносыОеовноегоНачисления(); // ИНАГРО ++
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетДт, "Дт");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетКт, "Кт");
	УстановитьДоступностьНУ(ЭтаФорма, Объект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьСпособОтраженияЕСВФОТ(ЭтаФорма);	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВзносыОеовноегоНачисления()
	
	Объект.ИНАГРО_ВзносыОсновногоНачисления = Объект.СтратегияОтраженияЕСВФОТ = Перечисления.СтратегииОтраженияВУчетеЕСВ.ОсобымСпособом;
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт1ПриИзменении(Элемент)
	УстановитьДоступностьНУ(ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт2ПриИзменении(Элемент)
	УстановитьДоступностьНУ(ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт3ПриИзменении(Элемент)
	УстановитьДоступностьНУ(ЭтаФорма, Объект);
КонецПроцедуры
