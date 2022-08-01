#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьВидРегистраБухгалтерскогоУчетаДляОтчета(ПолноеИмяОбъектаМетаданных, ВариантОтчета = "") Экспорт
	
	Если ВариантОтчета = Неопределено Тогда
		ВариантОтчета = "";
	КонецЕсли;	
	
	ИдентификаторОтчета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяОбъектаМетаданных);
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Отчет", ИдентификаторОтчета);
	Запрос.Параметры.Вставить("ВариантОтчета", ВариантОтчета);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыРегистровУчета.Ссылка
	|ИЗ
	|	Справочник.ВидыРегистровУчета КАК ВидыРегистровУчета
	|ГДЕ
	|	ВидыРегистровУчета.Отчет = &Отчет
	|	И ВидыРегистровУчета.ВариантОтчета = &ВариантОтчета
	|";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.ВидыРегистровУчета.ПустаяСсылка();
	
КонецФункции

Функция ЗаполнитьВидыРегистровУчета() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//Стандартные отчеты
	ВидРегистра = Справочники.ВидыРегистровУчета.АнализСубконто.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.АнализСубконто);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "АнализСубконто";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.АнализСчета.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.АнализСчета);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "АнализСчета";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ГлавнаяКнига.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ГлавнаяКнига);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.КарточкаСубконто.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.КарточкаСубконто);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "КарточкаСубконто";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.КарточкаСчета.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.КарточкаСчета);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "КарточкаСчета";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОборотноСальдоваяВедомость.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОборотноСальдоваяВедомость);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОборотноСальдоваяВедомость";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОборотноСальдоваяВедомостьПоСчету.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОборотноСальдоваяВедомостьПоСчету);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОборотноСальдоваяВедомостьПоСчету";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОборотыМеждуСубконто.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОборотыМеждуСубконто);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОборотыМеждуСубконто";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОборотыСчета.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОборотыСчета);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОборотыСчета";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОтчетПоПроводкам.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОтчетПоПроводкам);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОтчетПоПроводкам";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СводныеПроводки.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СводныеПроводки);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "СводныеПроводки";
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ШахматнаяВедомость.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ШахматнаяВедомость);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ШахматнаяВедомость";
	ВидРегистра.Записать();
	
	//Справки расчеты
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетКалькуляцияСебестоимости.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетКалькуляцияСебестоимости);
	ВидРегистра.ВариантОтчета = "КалькуляцияСебестоимости";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.Записать();
	
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетПереоценкаВалютныхСредств.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетПереоценкаВалютныхСредств);
	ВидРегистра.ВариантОтчета = "ПереоценкаВалютныхСредств";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.Записать();
	
	
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетРаспределенияКосвенныхРасходов.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетРаспределенияКосвенныхРасходов);
	ВидРегистра.ВариантОтчета = "СправкаРасчетРаспределенияКосвенныхРасходов";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.Записать();
	
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетСебестоимостиПродукцииИУслуг.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетСебестоимостиПродукцииИУслуг);
	ВидРегистра.ВариантОтчета = "СправкаРасчетСебестоимостиПродукцииИУслуг";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.Записать();
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетСписаниеРБП.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетСписаниеРБП);
	ВидРегистра.ВариантОтчета = "ВариантНастройкиРБП";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.Записать();
	
		
КонецФункции

Функция ПолучитьНаименованиеПоВарианту(ИмяВарианта, ВариантыНастроек)
	
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Если Вариант.Имя = ИмяВарианта Тогда
			Возврат Вариант.Представление;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("Отчет");
	Результат.Добавить("ВариантОтчета");
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли
