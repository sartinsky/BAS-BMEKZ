
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	КлючВарианта = НеОпределено;
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("КлючВарианта", КлючВарианта);
		
	Если КлючВарианта = "П6" Тогда
		
		Попытка 
			
			ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
			ДокументРезультат.АвтоМасштаб = Истина;
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

			НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
					
			МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
				НастройкиОтчета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

			СоответствиеПользовательскихПолей = ЗарплатаКадры.СоответствиеПользовательскихПолей(НастройкиОтчета.ПользовательскиеПоля.Элементы);
			ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);

			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ДаныеОтчета = Новый ДеревоЗначений;
			ПроцессорВывода.УстановитьОбъект(ДаныеОтчета);
			ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
			
			Макет = ПолучитьМакет("ПФ_MXL_П6");
			
			Для каждого СтрокаОрганизации Из ДаныеОтчета.Строки Цикл
				Если НЕ (СтрокаОрганизации.МесяцНачисления = Неопределено И СтрокаОрганизации.Организация = Неопределено) Тогда
					ВывестиОрганизациюП6(СтрокаОрганизации, ДокументРезультат, Макет, СоответствиеПользовательскихПолей);
				КонецЕсли;
			КонецЦикла;
			
			СтандартнаяОбработка = Ложь;
			
		Исключение
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение НСтр("ru='В настройку отчета Типовая форма П-6 внесены критичные изменения. Отчет не будет сформирован.';uk='У настройку звіту Типова форма П-6 внесено критичні зміни. Звіт не буде сформований.'") + " " + Инфо.Описание;
		КонецПопытки;
		
	ИначеЕсли КлючВарианта = "П7" Тогда
		
		Попытка 
			
			ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
			ДокументРезультат.АвтоМасштаб = Истина;
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

			НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
			
			//ЗарплатаКадры.ЗаполнитьПользовательскиеПоляВариантаОтчета(КлючВарианта, НастройкиОтчета.ПользовательскиеПоля.Элементы);
			
			МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
				НастройкиОтчета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

			СоответствиеПользовательскихПолей = ЗарплатаКадры.СоответствиеПользовательскихПолей(НастройкиОтчета.ПользовательскиеПоля.Элементы);
			
			ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);

			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ДаныеОтчета = Новый ДеревоЗначений;
			ПроцессорВывода.УстановитьОбъект(ДаныеОтчета);
			ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
			
			Макет = ПолучитьМакет("ПФ_MXL_П7");
			
			Для каждого СтрокаОрганизации Из ДаныеОтчета.Строки Цикл
				ВывестиОрганизациюП7(СтрокаОрганизации, ДокументРезультат, Макет, СоответствиеПользовательскихПолей);
			КонецЦикла;
			
			СтандартнаяОбработка = Ложь;
			
		Исключение
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение НСтр("ru='В настройку отчета Типовая форма П-7 внесены критичные изменения. Отчет не будет сформирован.';uk='У настройку звіту Типова форма П-7 внесено критичні зміни. Звіт не буде сформований.'") + " " + Инфо.Описание;
		КонецПопытки;
				
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиОрганизациюП6(СтрокаОрганизации, ДокументРезультат, Макет, СоответствиеПользовательскихПолей)
	
	Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	ОбластьОтчета = Макет.ПолучитьОбласть("ОбластьОтчета");
	ОбластьОтчета.Параметры.Заполнить(СтрокаОрганизации);
	
	Если СтрокаОрганизации.СотрудникФизическоеЛицоПол = Перечисления.ПолФизическогоЛица.Женский Тогда
		ОбластьОтчета.Параметры.СотрудникФизическоеЛицоПол = "ж"
	ИначеЕсли СтрокаОрганизации.СотрудникФизическоеЛицоПол = Перечисления.ПолФизическогоЛица.Мужской Тогда	
		ОбластьОтчета.Параметры.СотрудникФизическоеЛицоПол = "ч"
	КонецЕсли;
	ОбластьОтчета.Параметры.КодДолжности = СтрокаОрганизации.Должность.КодКП;
	ОбластьОтчета.Параметры.Дата = ТекущаяДата();
	ЗарплатаКадры.ЗаполнитьПараметрыПользовательскихПолей(ОбластьОтчета, СтрокаОрганизации, СоответствиеПользовательскихПолей);
	ОбластьОтчета.Параметры.Организация = ВРег(СтрокаОрганизации.Организация.НаименованиеПолное);
	СуммаПолейНачислений = 0;
	Для Ин = 1 По 48 Цикл
		ИмяПоля = "ПользовательскиеПоляПоле"+ Ин;	
		СуммаПолейНачислений = СуммаПолейНачислений + СтрокаОрганизации[ИмяПоля];
	КонецЦикла;
	ОбластьОтчета.Параметры.ВсегоНачислено = СуммаПолейНачислений;
	
	СуммаПолейУдержаний = 0;
	Для Ин = 50 По 55 Цикл
		ИмяПоля = "ПользовательскиеПоляПоле"+ Ин;	
		СуммаПолейУдержаний = СуммаПолейУдержаний + СтрокаОрганизации[ИмяПоля];
	КонецЦикла;
	ОбластьОтчета.Параметры.ВсегоУдержано = СуммаПолейУдержаний;

	Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(СтрокаОрганизации.Организация, ТекущаяДата());
	Если ЗначениеЗаполнено(Руководители.ГлавныйБухгалтерФИО) Тогда
		ОбластьОтчета.Параметры.ФИОГлавногоБухгалтера = ФизическиеЛицаКлиентСервер.ИмяФамилияВФорматеДСТУ(Руководители.ГлавныйБухгалтер.Наименование); 
	КонецЕсли;
	
	ДокументРезультат.Вывести(ОбластьОтчета);

КонецПроцедуры

Процедура ВывестиОрганизациюП7(СтрокаОрганизации, ДокументРезультат, Макет, СоответствиеПользовательскихПолей)
	
	Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	ОбластьОтчета = Макет.ПолучитьОбласть("ОбластьОтчета");
	ОбластьОтчета.Параметры.Заполнить(СтрокаОрганизации);
	ОбластьОтчета.Параметры.Дата = ТекущаяДата();
	ЗарплатаКадры.ЗаполнитьПараметрыПользовательскихПолей(ОбластьОтчета, СтрокаОрганизации, СоответствиеПользовательскихПолей);
	ОбластьОтчета.Параметры.Организация = ВРег(СтрокаОрганизации.Организация.НаименованиеПолное);
	ДокументРезультат.Вывести(ОбластьОтчета);
	ОбластьТаблицы = Макет.ПолучитьОбласть("ОбластьТаблицы");
	Для Каждого СтрокаТаблицы Из СтрокаОрганизации.Строки Цикл
		ОбластьТаблицы.Параметры.Заполнить(СтрокаТаблицы);
		ЗарплатаКадры.ЗаполнитьПараметрыПользовательскихПолей(ОбластьТаблицы, СтрокаТаблицы, СоответствиеПользовательскихПолей);
		
		СуммаПолейНачислений = 0;
		Для Ин = 1 По 48 Цикл
			ИмяПоля = "ПользовательскиеПоляПоле"+ Ин;	
			СуммаПолейНачислений = СуммаПолейНачислений + СтрокаТаблицы[ИмяПоля];
		КонецЦикла;
		ОбластьТаблицы.Параметры.ВсегоНачислено = СуммаПолейНачислений;
		
		СуммаПолейУдержаний = 0;
		Для Ин = 50 По 55 Цикл
			ИмяПоля = "ПользовательскиеПоляПоле"+ Ин;	
			СуммаПолейУдержаний = СуммаПолейУдержаний + СтрокаТаблицы[ИмяПоля];
		КонецЦикла;
		ОбластьТаблицы.Параметры.ВсегоУдержано = СуммаПолейУдержаний;	
	КонецЦикла;
		
	Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(СтрокаОрганизации.Организация, ТекущаяДата());
	Если ЗначениеЗаполнено(Руководители.ГлавныйБухгалтерФИО) Тогда
		ОбластьТаблицы.Параметры.ФИОГлавногоБухгалтера = ФизическиеЛицаКлиентСервер.ИмяФамилияВФорматеДСТУ(Руководители.ГлавныйБухгалтер.Наименование); 
	КонецЕсли;
	
	ДокументРезультат.Вывести(ОбластьТаблицы);

КонецПроцедуры

#КонецОбласти

#КонецЕсли