#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	ПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных; 
		
	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм();
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачальноеСальдо", НСтр("ru='Начальное сальдо';uk='Початкове сальдо'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КонечноеСальдо", НСтр("ru='Конечное сальдо';uk='Кінцеве сальдо'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НДФЛ", НСтр("ru='НДФЛ';uk='ПДФО'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ОтработаноДней", НСтр("ru='Отработано дней';uk='Відпрацьовано днів'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ОтработаноЧасов", НСтр("ru='Отработано часов';uk='Відпрацьовано годин'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ЧерезБанк", НСтр("ru='Через банк';uk='Через банк'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ЧерезКассу", НСтр("ru='Через кассу';uk='Через касу'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВедомостьРеализация", НСтр("ru='Ведомость реализация';uk='Відомість реалізація'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДолгФСС", НСтр("ru='Конечный долг за ФСС';uk='Кінцевий борг за ФСС'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДолгФССНаНачало", НСтр("ru='Начальный долг за ФСС';uk='Початковий борг за ФСС'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КВыплатеЗаМесяц", НСтр("ru='К выплате за период';uk='До виплати за період'",КодЯзыкаПечать));
		
	// ВОЕННЫЙ СБОР
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВоенныйСбор", НСтр("ru='Военный сбор';uk='Військовий збір'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПогашениеЗайма", НСтр("ru='Погашение займа';uk='Погашення позики'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Задепонировано", НСтр("ru='Задепонировано';uk='Задепоновано'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПоВнутрСовм", НСтр("ru='(по внутр. совмест-ву)';uk='(за внутр. сумісн-вом)'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВсегоНачислено", НСтр("ru='Всего начислено';uk='Всього нараховано'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВсегоУдержано", НСтр("ru='Всего удержано';uk='Всього утримано'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВсегоВыплачено", НСтр("ru='Всего выплачено';uk='Всього виплачено'",КодЯзыкаПечать));
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки,ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных,,ДанныеРасшифровки,Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных,Истина);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
